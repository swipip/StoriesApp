import Foundation

@MainActor
final class StoriesListViewModel: ObservableObject {

    @Published var selectedStory: StoryViewData?
    @Published private(set) var stories: [StoryViewData] = []

    private weak var provider: (any StoriesProvider & StoriesListProvider)?

    private var currentPage: Int = 0

    init(provider: some StoriesProvider & StoriesListProvider) {
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

    func loadNextPage() async {
        guard let provider else { return }
        do {
            stories = try await provider.loadPage(index: currentPage + 1)
        } catch {
            // ..
        }
    }
}
