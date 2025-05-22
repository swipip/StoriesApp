import Foundation

package protocol StoriesProvider: AnyObject, Sendable {

    func loadStories() async throws -> [StoryViewData]
}
