import Foundation
import StoriesCore
import StoriesUI

extension StoriesRepository: StoriesListProvider {
    package func loadPage(index: Int) async throws -> [StoryViewData] {
        try await loadAdditionalStories(index: index).map(\.toViewData)
    }
}
