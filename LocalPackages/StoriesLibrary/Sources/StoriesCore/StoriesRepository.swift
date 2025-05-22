import Foundation

package actor StoriesRepository {

    package enum RepositoryError: Error {
        case serverError
    }

    private let service: StoriesService
    private var cachedStories: [StoryModel] = []

    public init(service: StoriesService) {
        self.service = service
    }

    // MARK: API

    package func getStories() async throws(RepositoryError) -> [StoryModel] {
        []
    }

    package func updateStoryLiked(liked: Bool, storyId: UUID, pageId: UUID) async throws(RepositoryError) {
        // ..
    }
}
