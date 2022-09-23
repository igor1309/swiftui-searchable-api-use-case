//
//  Asset.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

public struct Asset: Hashable, Identifiable {
    let title: String
    let text: String
    let type: AssetType
    
    public var id: String { title }
    var icon: String { type.icon }
}
