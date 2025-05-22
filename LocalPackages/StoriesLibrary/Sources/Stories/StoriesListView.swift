import SwiftUI
import StoriesUI
import StoriesCore

public struct SelectedStory: Identifiable {
    public let id: UUID

    public init(id: UUID) {
        self.id = id
    }
}

public struct StoriesListView: View {

    private let provider = StoriesRepository(service: .mock)
    private let handler: (_ storyId: SelectedStory) -> Void

    public init(handler: @escaping (_: SelectedStory) -> Void) {
        self.handler = handler
    }

    public var body: some View {
        StoriesUI.StoriesListView(provider: provider) { storyId in
            handler(SelectedStory(id: storyId))
        }
    }
}
