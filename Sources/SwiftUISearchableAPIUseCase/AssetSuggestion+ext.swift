//
//  AssetSuggestion+ext.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

extension Array where Element == AssetSuggestion {
    static let samples: Self = [
        .bitcoin, .etherium, .tether, .usdFuture, .usStock, .usdEur
    ]
}

extension AssetSuggestion {
    static let bitcoin: Self = .init(title: "Bitcoin", text: "btcusd", type: .crypto)
    static let etherium: Self = .init(title: "Etherium", text: "ethusd", type: .crypto)
    static let tether: Self = .init(title: "Tether", text: "usdt", type: .crypto)
    static let usdFuture: Self = .init(title: "USD Future", text: "usdf", type: .derivative)
    static let usStock: Self = .init(title: "US Stock", text: "uss", type: .stock)
    static let usdEur: Self = .init(title: "USD/EUR", text: "usdeur", type: .currency)
}
