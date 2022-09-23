//
//  AssetSuggestion.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

struct AssetSuggestion: Identifiable {
    let title: String
    let text: String
    let type: AssetType
    
    var id: String { title }
    var icon: String { type.icon }
}
