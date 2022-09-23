//
//  SearchableAPIUseCasePreviewApp.swift
//  SearchableAPIUseCasePreview
//
//  Created by Igor Malyarov on 23.09.2022.
//

import SwiftUISearchableAPIUseCase
import SwiftUI

@main
struct SearchableAPIUseCasePreviewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init(search: searchPublisher))
        }
    }
}
