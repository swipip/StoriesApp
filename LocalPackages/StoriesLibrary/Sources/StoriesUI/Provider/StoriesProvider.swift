import Foundation

package protocol StoriesProvider: AnyObject, Sendable {

    func loadStories() async throws -> [StoryViewData]
    func setStoryLiked(liked: Bool, storyId: UUID, pageId: UUID) async throws
}
