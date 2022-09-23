//
//  ViewModel.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

import Combine
import Foundation

final class ViewModel: ObservableObject {
    @Published var searchText = ""
    @Published private var suggestions = [Asset].samples
    @Published private(set) var searchResults = [SearchResultItem]()
    @Published var assetType: Asset.AssetType?
    
    var isSearching: Bool = false
    
    typealias SearchResultsPublisher = AnyPublisher<[SearchResultItem], Never>
    
    init(search: @escaping (String) -> SearchResultsPublisher) {
        $searchText
            .flatMap(search)
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchResults)
    }
    
    var searchSuggestions: [Asset] {
        suggestions.filter {
            $0.title.lowercased().hasPrefix(searchText.lowercased())
            && (assetType == nil ? true : $0.type == assetType)
        }
    }
    
    //    var filteredMessages: [Message] {
    //        if searchText.isEmpty {
    //            return messages
    //        } else {
    //            return messages.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
    //        }
    //    }
    
    func setIsSearching(to isSearching: Bool) {
        self.isSearching = isSearching
    }
}

struct SearchResultItem: Identifiable {
    let title: String
    
    var id: String { title }
}

struct Asset: Identifiable {
    let title: String
    let text: String
    let icon: String
    let type: AssetType
    
    var id: String { title }

    enum AssetType: String, CaseIterable {
        case currency
        case crypto
        case stock
        case derivative
    }
}

extension Array where Element == SearchResultItem {
    static let samples: Self = [
        "uu", "uuu", "uuuu", "uuuuu", "uuuuuu", "uuuuuuu",
        "bbbb", "ccc", "dd"]
        .map(SearchResultItem.init)
}

extension Array where Element == Asset {
    static let samples: Self = [
        .init(title: "usdt", text: "tether", icon: "t.circle", type: .crypto),
        .init(title: "usdf", text: "USD Future", icon: "dollarsign.circle", type: .derivative),
        .init(title: "uss", text: "US Stock", icon: "dollarsign.square", type: .stock),
        .init(title: "usdeur", text: "USD/EUR", icon: "eurosign.circle", type: .currency),
    ]
}
