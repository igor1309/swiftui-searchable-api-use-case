//
//  ViewModel.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

import Combine
import Foundation

final class ViewModel: ObservableObject {
    @Published private var watchedAssets = [Asset]()
    @Published private var searchResults = [Asset]()
    @Published var searchText = ""
    @Published var assetType: AssetType?
    @Published private var suggestions = [AssetSuggestion].samples
    
    private var isSearching: Bool = false
    
    typealias SearchResultsPublisher = AnyPublisher<[Asset], Never>
    
    init(search: @escaping (String) -> SearchResultsPublisher) {
        $searchText
            .flatMap(search)
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchResults)
    }
    
    var shouldShowSearchResults: Bool {
        isSearching && !searchText.isEmpty
    }

    var assets: [Asset] {
        shouldShowSearchResults
        ? searchResults.filter { isSelected($0.type) }
        : watchedAssets
    }
    
    var searchSuggestions: [AssetSuggestion] {
        suggestions.filter {
            searchText.isEmpty && isSelected($0.type)
        }
    }
    
    private func isSelected(_ type: AssetType) -> Bool {
        assetType == nil ? true : type == assetType
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
    
    func isInList(_ item: Asset) -> Bool {
        Set(watchedAssets).contains(item)
    }
    
    func toggleItem(_ item: Asset) {
        if isInList(item) {
            watchedAssets.removeAll(where: { $0 == item })
        } else {
            watchedAssets.append(item)
        }
    }
}

struct Asset: Hashable, Identifiable {
    let title: String
    let text: String
    let type: AssetType
    
    var id: String { title }
    var icon: String { type.icon }
}

struct AssetSuggestion: Identifiable {
    let title: String
    let text: String
    let type: AssetType
    
    var id: String { title }
    var icon: String { type.icon }
}

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

extension Array where Element == Asset {
    static let samples: Self = [
        .init(title: "Bitcoin", text: "btcusd", type: .crypto),
        .init(title: "Bitcoin/€", text: "btceur", type: .crypto),
        .init(title: "Tether", text: "usdt", type: .crypto),
        .init(title: "USD Future", text: "usdf", type: .derivative),
        .init(title: "US Stock", text: "uss", type: .stock),
        .init(title: "USD/EUR", text: "usdeur", type: .currency),
    ]
}

extension Array where Element == AssetSuggestion {
    static let samples: Self = [
        .init(title: "Bitcoin", text: "btcusd", type: .crypto),
        .init(title: "Etherium", text: "ethusd", type: .crypto),
        .init(title: "Tether", text: "usdt", type: .crypto),
        .init(title: "USD Future", text: "usdf", type: .derivative),
        .init(title: "US Stock", text: "uss", type: .stock),
        .init(title: "USD/EUR", text: "usdeur", type: .currency),
    ]
}
