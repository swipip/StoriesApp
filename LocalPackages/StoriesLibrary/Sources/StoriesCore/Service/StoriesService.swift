import Foundation

package struct StoriesService: Sendable {
    let storiesFetcher: @Sendable () async throws -> [StoryModel]
    let setStoryPageLiked: @Sendable (_ storyId: UUID, _ pageId: UUID, _ liked: Bool) async throws -> Void

    package init(storiesFetcher: @Sendable @escaping () async throws -> [StoryModel],
                 setStoryPageLiked: @Sendable @escaping (_ storyId: UUID, _ pageId: UUID, _ liked: Bool) async throws -> Void) {
        self.storiesFetcher = storiesFetcher
        self.setStoryPageLiked = setStoryPageLiked
    }
}
