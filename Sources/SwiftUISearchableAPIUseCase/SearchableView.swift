//
//  SearchableView.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

import SwiftUI

struct SearchableView<Content: View>: View {
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

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchableView(setIsSearching: { _ in }) {
                List {
                    ForEach([Asset].samples, content: AssetView.init)
                }
            }
            .listStyle(.plain)
            .navigationBarTitle("Assets")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }
}
