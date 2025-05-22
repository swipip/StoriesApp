import Foundation

@MainActor
final class StoriesScreenViewModel: ObservableObject {

    @Published var selectedStory: StoryViewData?
    @Published var stories: [StoryViewData] = []

    private weak var provider: (any StoriesProvider)?

    init(provider: some StoriesProvider) {
        self.provider = provider
    }

    func load() async {
        do {
            let stories = try await provider?.loadStories()
            self.stories = stories ?? []
            self.selectedStory = stories?.first
        } catch {
            // Handle error
        }
    }
}
