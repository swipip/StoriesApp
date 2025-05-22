import SwiftUI
import StoriesUI
import StoriesCore

public struct StoriesScreen: View {

    @Environment(\.dismiss) private var dismissAction

    private let provider = StoriesRepository(service: .mock)
    private let story: SelectedStory?

    public init(story: SelectedStory?) {
        self.story = story
    }

    public var body: some View {
        StoriesUI.StoriesScreen(provider: provider, selectedStoryId: story?.id) {
            dismissAction()
        }
    }
}
