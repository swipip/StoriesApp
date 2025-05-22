import Foundation

@MainActor
final class StoriesListViewModel: ObservableObject {

    @Published var selectedStory: StoryViewData?
    @Published private(set) var stories: [StoryViewData] = []

    private weak var provider: (any StoriesProvider)?

    init(provider: some StoriesProvider) {
        self.provider = provider
    }

    func load() async {
        do {
            stories = try await provider?.loadStories() ?? []
            selectedStory = stories.first
        } catch {
            // ..
        }
    }

}
