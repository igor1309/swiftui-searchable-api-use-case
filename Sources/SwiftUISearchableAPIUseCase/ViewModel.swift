//
//  ViewModel.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

import Combine
import Foundation

public final class ViewModel: ObservableObject {
    @Published private var watchedAssets = [Asset]()
    @Published private var searchResults = [Asset]()
    @Published var searchText = ""
    @Published var assetType: AssetType?
    @Published private var suggestions = [AssetSuggestion].samples
    
    private var isSearching: Bool = false
    
    public typealias SearchResultsPublisher = AnyPublisher<[Asset], Never>
    
    public init(search: @escaping (String) -> SearchResultsPublisher) {
        $searchText
            .flatMap(search)
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchResults)
    }
    
    var isSearchTextEmpty: Bool {
        searchText.isEmpty
    }
    
    var shouldShowSearchResults: Bool {
        isSearching && !searchText.isEmpty
    }

    var shouldShowSuggestions: Bool {
        watchedAssets.isEmpty
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
    
    func isInList(_ asset: Asset) -> Bool {
        Set(watchedAssets).contains(asset)
    }
    
    func toggleInList(_ asset: Asset) {
        if isInList(asset) {
            remove(asset: asset)
        } else {
            watchedAssets.append(asset)
        }
    }
    
    func remove(asset: Asset) {
        watchedAssets.removeAll(where: { $0 == asset })
    }
}
