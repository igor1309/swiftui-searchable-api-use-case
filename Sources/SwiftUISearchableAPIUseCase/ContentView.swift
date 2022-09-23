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
            ListView(
                assets: viewModel.assets,
                setIsSearching: viewModel.setIsSearching,
                assetView: assetView
            )
            .listStyle(.plain)
            .navigationTitle("Watch List")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Enter \"U\" to start"
        )
        .searchScopes($viewModel.assetType) {
            if !viewModel.isSearchTextEmpty {
                ForEach(AssetType.allCases + [nil], id: \.self) { scope in
                    Text(scope?.rawValue ?? "all")
                        .tag(scope)
                }
            }
        }
//        .searchSuggestions {
//            ForEach(viewModel.searchSuggestions, content: searchSuggestionView)
//        }
    }

    @ViewBuilder
    private func assetView(asset: Asset) -> some View {
        if viewModel.shouldShowSearchResults {
            SearchAssetView(
                asset: asset,
                isInList: viewModel.isInList(asset),
                toggleInList: viewModel.toggleInList
            )
        } else {
            AssetView(asset: asset)
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
