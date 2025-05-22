import SwiftUI
import StoriesUI
import StoriesCore

public struct StoriesScreen: View {

    @Environment(\.dismiss) private var dismissAction

    private let provider = StoriesRepository(service: .mock)

    public init() {
        // ..
    }

    public var body: some View {
        StoriesUI.StoriesScreen(provider: provider) {
            dismissAction()
        }
    }
}
