//
//  AssetType.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

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
