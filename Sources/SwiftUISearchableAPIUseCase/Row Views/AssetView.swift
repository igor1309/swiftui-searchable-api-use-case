//
//  AssetView.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

import SwiftUI

struct AssetView: View {
    let asset: Asset
    
    var body: some View {
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

struct AssetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                AssetView(asset: .bitcoin)
                AssetView(asset: .etherium)
                AssetView(asset: .tether)
                AssetView(asset: .usdFuture)
                AssetView(asset: .usStock)
                AssetView(asset: .usdEur)
            }
            .listStyle(.plain)
            .navigationTitle("Assets")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }
}
