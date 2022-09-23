//
//  ContentView.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

import Combine
import SwiftUI

public struct ContentView: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            SearchableView(setIsSearching: viewModel.setIsSearching) {
                List {
                    ForEach(viewModel.assets, content: assetView)
                }
            }
            .animation(.easeInOut, value: viewModel.assets)
            .listStyle(.plain)
            .navigationTitle("Watch List")
            // .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search currencies, cryptos, stocks..."
        )
        .searchScopes($viewModel.assetType, scopes: scopes)
        .searchSuggestions(searchSuggestions)
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
                .contextMenu {
                    Button(role: .destructive) {
                        viewModel.remove(asset: asset)
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                }
        }
    }
    
    @ViewBuilder
    private func scopes() -> some View {
        if !viewModel.isSearchTextEmpty {
            ForEach(AssetType.allCases + [nil], id: \.self) { scope in
                Text(scope?.rawValue ?? "all")
                    .tag(scope)
            }
        }
    }
    
    private func searchSuggestions() -> some View {
        ForEach(viewModel.searchSuggestions, content: searchSuggestionView)
    }
    
    private func searchSuggestionView(item: AssetSuggestion) -> some View {
        Label(item.title, systemImage: item.icon)
            .searchCompletion(item.text)
    }
}

/// Utility view: the main purpose of this view is to report back to the parent
/// the `isSearching` state from the `Environment`.
private struct SearchableView<Content: View>: View {
    @Environment(\.isSearching) private var isSearching
    
    private let setIsSearching: (Bool) -> Void
    private let content: () -> Content
    
    init(
        setIsSearching: @escaping (Bool) -> Void,
        content: @escaping () -> Content
    ) {
        self.setIsSearching = setIsSearching
        self.content = content
    }
    
    var body: some View {
        content()
            .onChange(of: isSearching, perform: setIsSearching)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(search: searchPublisher))
            .preferredColorScheme(.dark)
    }
}
