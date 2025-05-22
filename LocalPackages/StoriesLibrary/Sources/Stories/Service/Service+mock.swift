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
        var stories = [StoryModel]()
        let numberOfStories = Int.random(in: 3 ... 8)
        for index in 0 ..< numberOfStories {
            var pages = [PageModel]()

            let numberOfPages = Int.random(in: 1 ... 10)
            let user = randomUser(index: index)

            for pageIndex in 0 ..< numberOfPages {
                let asset = AssetModel(id: UUID(), mediaUrl: randomUrl())
                pages.append(PageModel(id: UUID(), index: pageIndex, asset: asset, displayDuration: 10, liked: false, viewed: true))
            }

            stories.append(StoryModel(id: UUID(), user: user, index: index, viewed: false, postedAt: .distantPast, pages: pages))
        }

        cachedStories = stories

        return stories
    }

    private func randomUrl() -> URL {
        URL(string: "https://picsum.photos/1200/2400?random=\(UUID().uuidString)")!
    }

    private func randomUser(index: Int) -> UserModel {
        UserModel(
            id: UUID(),
            username: "user\(index)",
            profileImageURL: randomUserUrl(),
            isApproved: .random(),
            communication: Bool.random() ? nil : "partenariat commercial avec **Adidas**",
            postedSince: "\((8 ... 22).randomElement() ?? 2) h")
    }

    private func randomUserUrl() -> URL {
        let type = ["men", "women"].randomElement() ?? "men"
        let index = (0 ..< 99).randomElement() ?? 1

        let url =  URL(string: "https://randomuser.me/api/portraits/\(type)/\(index).jpg")!
        print(url)

        return url
    }
}
