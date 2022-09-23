//
//  SearchAssetView.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

import SwiftUI

struct SearchAssetView: View {
    let asset: Asset
    let isInList: Bool
    let toggleInList: (Asset) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            toggleInListButton(asset)
            
            VStack(alignment: .leading) {
                Text(asset.title)
                
                Text(asset.text)
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
    }
    
    @ViewBuilder
    private func toggleInListButton(_ asset: Asset) -> some View {
        let title = isInList ? "Item in list" : "Add item to list"
        let systemImage = isInList ? "checkmark" : "plus"
        let foregroundColor = isInList ? Color.green : .accentColor
        
        Button {
            toggleInList(asset)
        } label: {
            Label(title, systemImage: systemImage)
                .labelStyle(.iconOnly)
                .symbolVariant(.circle)
                .symbolVariant(.fill)
                .symbolRenderingMode(.hierarchical)
                .imageScale(.large)
        }
        .buttonStyle(.plain)
        .foregroundColor(foregroundColor)
    }
}

struct SearchResultAssetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                SearchAssetView(
                    asset: .bitcoin,
                    isInList: true,
                    toggleInList: { _ in }
                )
                SearchAssetView(
                    asset: .etherium,
                    isInList: false,
                    toggleInList: { _ in }
                )
            }
            .listStyle(.plain)
            .navigationTitle("Assets")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }
}
