//
//  ContentView.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

import Combine
import SwiftUI

struct ListView: View {
    @Environment(\.isSearching) var isSearching
    
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            ForEach(viewModel.searchResults, content: searchResultView)
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                Text(isSearching ? "Searching" : "Not Searching")
                Text(viewModel.isSearching ? "Searching" : "Not Searching")
                    .foregroundColor(.secondary)
            }
            .font(.caption)
        }
        .onChange(of: isSearching, perform: viewModel.setIsSearching(to:))
    }
    
    private func searchResultView(item: SearchResultItem) -> some View {
        Text(item.title)
            .font(.headline)
    }
}

struct ContentView: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ListView(viewModel: viewModel)
                .listStyle(.plain)
                .navigationTitle("Title")
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Enter \"U\" or \"Uu\" to start"
        )
        .searchScopes($viewModel.assetType) {
            ForEach(Asset.AssetType.allCases + [nil], id: \.self) { scope in
                Text(scope?.rawValue ?? "all")
                    .tag(scope)
            }
        }
        .searchSuggestions {
            ForEach(viewModel.searchSuggestions, content: searchSuggestionView)
        }
    }
    
    private func searchSuggestionView(item: Asset) -> some View {
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
