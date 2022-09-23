//
//  ListView.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

import SwiftUI

struct ListView<AssetView: View>: View {
    
    @Environment(\.isSearching) private var isSearching
    
    private let assets: [Asset]
    private let setIsSearching: (Bool) -> Void
    private let assetView: (Asset) -> AssetView
    
    init(
        assets: [Asset],
        setIsSearching: @escaping (Bool) -> Void,
        assetView: @escaping (Asset) -> AssetView
    ) {
        self.assets = assets
        self.setIsSearching = setIsSearching
        self.assetView = assetView
    }
    
    var body: some View {
        List {
            ForEach(assets, content: assetView)
        }
        .onChange(of: isSearching, perform: setIsSearching)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView(
                assets: .samples,
                setIsSearching: { _ in }
            ) { Text($0.title) }
                .listStyle(.plain)
                .navigationBarTitle("Assets")
                .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }
}
