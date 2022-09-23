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
    private func searchResultView(asset: Asset) -> some View {
        if viewModel.shouldShowSearchResults {
            SearchResultAssetView(
                asset: asset,
                isInList: viewModel.isInList(asset),
                toggleInList: viewModel.toggleInList
            )
        } else {
            HStack(spacing: 16) {
                Image(systemName: asset.icon)
                    .imageScale(.large)
                    
                VStack(alignment: .leading) {
                    Text(asset.title)
                        .font(.headline)
                    
                    Text(asset.text)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
            }
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
        .searchSuggestions {
            ForEach(viewModel.searchSuggestions, content: searchSuggestionView)
        }
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
