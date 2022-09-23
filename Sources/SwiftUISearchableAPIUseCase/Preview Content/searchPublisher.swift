//
//  SwiftUIView.swift
//  
//
//  Created by Igor Malyarov on 23.09.2022.
//

import Combine

public let searchPublisher: (String) -> ViewModel.SearchResultsPublisher = { string in
    let filtered = [Asset].samples
        .filter { $0.title.lowercased().hasPrefix(string.lowercased()) }
    
    return Just(filtered)
        .eraseToAnyPublisher()
}
