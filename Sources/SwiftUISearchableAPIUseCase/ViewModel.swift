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
    let type: AssetType
    
    var id: String { title }
    var icon: String { type.icon }

    enum AssetType: String, CaseIterable {
        case currency
        case crypto
        case stock
        case derivative
        
        var icon: String {
            switch self {
            case .currency:
                return "dollarsign.circle"
            case .crypto:
                return "bitcoinsign.square"
            case .stock:
                return "folder"
            case .derivative:
                return "scribble.variable"
            }
        }
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
        .init(title: "Tether", text: "usdt", type: .crypto),
        .init(title: "USD Future", text: "usdf", type: .derivative),
        .init(title: "US Stock", text: "uss", type: .stock),
        .init(title: "USD/EUR", text: "usdeur", type: .currency),
    ]
}
