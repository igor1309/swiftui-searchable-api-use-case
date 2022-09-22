//
//  ContentView.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

import Combine
import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.searchResults, content: searchResultView)
            }
            .listStyle(.plain)
            .navigationTitle("Title")
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search"
        )
        .searchScopes($viewModel.scope) {
            ForEach(ViewModel.SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue)
                    .tag(scope)
            }
        }
        .searchSuggestions {
            ForEach(viewModel.searchSuggestions, content: searchSuggestionView)
        }
    }
    
    private func searchResultView(item: SearchResultItem) -> some View {
        Text(item.title)
            .font(.headline)
    }
    
    private func searchSuggestionView(item: SearchSuggestionItem) -> some View {
        Label(item.title, systemImage: item.icon)
            .searchCompletion(item.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(search: searchPublisher))
            .preferredColorScheme(.dark)
    }
}

private let searchPublisher: (String) -> ViewModel.SearchResultsPublisher = { string in
    let filtered = [SearchResultItem].samples
        .filter { $0.title.lowercased().hasPrefix(string.lowercased()) }
    
    return Just(filtered)
        .eraseToAnyPublisher()
}


