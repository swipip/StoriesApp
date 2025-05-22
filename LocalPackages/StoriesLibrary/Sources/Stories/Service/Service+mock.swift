import Foundation
import StoriesCore

package extension StoriesService {
    static var mock: StoriesService {
        StoriesService {
            await MockService.shared.loadStories()
        }
    }
}

private actor MockService {

    enum ServiceError: Error {
        case serverError
    }

    static let shared = MockService()

    private var cachedStories: [StoryModel] = []

    private init() {
        // ..
    }

    func loadStories() async -> [StoryModel] {
        []
    }

}
