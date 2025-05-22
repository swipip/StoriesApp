import Foundation

package struct StoriesService: Sendable {
    let storiesFetcher: @Sendable () async throws -> [StoryModel]
    let storiesPageFetcher: @Sendable (_ pageIndex: Int) async throws -> [StoryModel]
    let setStoryPageLiked: @Sendable (_ storyId: UUID, _ pageId: UUID, _ liked: Bool) async throws -> Void

    package init(storiesFetcher: @Sendable @escaping () async throws -> [StoryModel],
                 storiesPageFetcher: @Sendable @escaping (_: Int) async throws -> [StoryModel],
                 setStoryPageLiked: @Sendable @escaping (_: UUID, _: UUID, _: Bool) async throws -> Void) {
        self.storiesFetcher = storiesFetcher
        self.storiesPageFetcher = storiesPageFetcher
        self.setStoryPageLiked = setStoryPageLiked
    }
}
