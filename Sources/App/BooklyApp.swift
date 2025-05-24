import ComposableArchitecture
import SwiftUI

@main
struct BooklyApp: App {
    static let store = Store(initialState: LibraryFeature.State()) {
        LibraryFeature()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LibraryView(store: BooklyApp.store)
            }
        }
    }
}
