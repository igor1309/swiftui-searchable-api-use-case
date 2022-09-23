//
//  ListView.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

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
            AssetView(asset: asset)
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView(viewModel: .init(search: searchPublisher))
        }
        .preferredColorScheme(.dark)
    }
}
