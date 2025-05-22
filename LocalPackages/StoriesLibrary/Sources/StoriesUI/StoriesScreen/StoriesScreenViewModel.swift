import Foundation

@MainActor
final class StoriesScreenViewModel: ObservableObject {

    @Published var selectedStory: StoryViewData?
    @Published var stories: [StoryViewData] = []

    private weak var provider: (any StoriesProvider)?

    private let selectedStoryId: UUID?

    init(provider: some StoriesProvider, selectedStoryId: UUID?) {
        self.provider = provider
        self.selectedStoryId = selectedStoryId
    }

    func load() async {
        do {
            let stories = try await provider?.loadStories()
            self.stories = stories ?? []
            if let selectedStoryId, let matchingStory = stories?.first(where: { $0.id == selectedStoryId}) {
                self.selectedStory = matchingStory
            } else {
                self.selectedStory = stories?.first
            }
        } catch {
            // Handle error
        }
    }

    func selectNextStory(_ onEndReached: () -> Void) {
        guard selectedStory != stories.last else {
            onEndReached()
            return
        }
        guard let currentIndex = selectedStory?.index else { return }

        let storiesCount = stories.count

        selectedStory = stories[min(currentIndex + 1, storiesCount - 1)]
    }

    func selectPreviousStory() {
        guard let currentIndex = selectedStory?.index else { return }
        selectedStory = stories[max(currentIndex - 1, 0)]
    }

    func setStoryLiked(_ liked: Bool, page: StoryPageViewData) {
        guard let selectedStory else { return }
        Task {
            do {
                try await provider?.setStoryLiked(liked: liked, storyId: selectedStory.id, pageId: page.id)
            } catch {
                // ..
            }
        }
    }
}
