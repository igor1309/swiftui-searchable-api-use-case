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
            ForEach(viewModel.assets, content: searchResultView)
        }
        .onChange(of: isSearching, perform: viewModel.setIsSearching(to:))
    }
    
    @ViewBuilder
    private func searchResultView(item: Asset) -> some View {
        if viewModel.shouldShowSearchResults {
            HStack {
                let isInList = viewModel.isInList(item)
                let title = isInList ? "Item in list" : "Add item to list"
                let systemImage = isInList ? "checkmark" : "plus"
                
                Button {
                    viewModel.toggleItem(item)
                } label: {
                    Label(title, systemImage: systemImage)
                        .labelStyle(.iconOnly)
                        .symbolVariant(.circle)
                        .symbolVariant(.fill)
                        .symbolRenderingMode(.hierarchical)
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
                .foregroundColor(isInList ? .green : .accentColor)
             
                Text(item.title)
            }
        } else {
            Text(item.title)
                .font(.headline)
        }
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
            ForEach(AssetType.allCases + [nil], id: \.self) { scope in
                Text(scope?.rawValue ?? "all")
                    .tag(scope)
            }
        }
//        .searchSuggestions {
//            ForEach(viewModel.searchSuggestions, content: searchSuggestionView)
//        }
    }
    
    private func searchSuggestionView(item: AssetSuggestion) -> some View {
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
    let filtered = [Asset].samples
        .filter { $0.title.lowercased().hasPrefix(string.lowercased()) }
    
    return Just(filtered)
        .eraseToAnyPublisher()
}
