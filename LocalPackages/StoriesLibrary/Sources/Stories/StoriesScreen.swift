import SwiftUI
import StoriesUI
import StoriesCore

public struct StoriesScreen: View {

    private let provider = StoriesRepository(service: .mock)

    public init() {
        // ..
    }

    public var body: some View {
        StoriesUI.StoriesScreen(provider: provider) {
            // dismiss when presented
        }
    }
}
