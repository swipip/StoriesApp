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
        do {
            cachedStories = try await service.storiesFetcher()
            return cachedStories
        } catch {
            throw .serverError
        }
    }

    package func updateStoryLiked(liked: Bool, storyId: UUID, pageId: UUID) async throws(RepositoryError) {
        do {
            try await service.setStoryPageLiked(storyId, pageId, liked)
        } catch {
            throw .serverError
        }
    }

    package func loadAdditionalStories(index: Int) async throws(RepositoryError) -> [StoryModel] {
        do {
            return try await service.storiesPageFetcher(index)
        } catch {
            throw .serverError
        }
    }
}
