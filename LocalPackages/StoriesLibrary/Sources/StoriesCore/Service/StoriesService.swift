import Foundation

package struct StoriesService: Sendable {
    let storiesFetcher: @Sendable () async throws -> [StoryModel]

    package init(storiesFetcher: @Sendable @escaping () async throws -> [StoryModel]) {
        self.storiesFetcher = storiesFetcher
    }
}
