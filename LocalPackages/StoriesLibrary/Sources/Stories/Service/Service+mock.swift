import Foundation
import StoriesCore

package extension StoriesService {
    static var mock: StoriesService {
        StoriesService {
            await MockService.shared.loadStories()
        } setStoryPageLiked: { storyId, pageId, liked in
            try await MockService.shared.setStoryLiked(storyId: storyId, pageId: pageId, liked: liked)
        }
    }
}

private actor MockService {

    private let persistentStore: UserDefaults

    private enum Constant {
        static let storiesKey: String = "com.stories.app.stories"
    }

    enum ServiceError: Error {
        case serverError
    }

    static let shared = MockService(persistentStore: .standard)

    private var cachedStories: [StoryModel] = []

    private init(persistentStore: UserDefaults) {
        self.persistentStore = persistentStore
    }

    func setStoryLiked(storyId: UUID, pageId: UUID, liked: Bool) async throws(ServiceError) -> StoryModel {
        guard let story = cachedStories[storyId], let page = story.pages[pageId] else {
            throw .serverError
        }

        let newPage = PageModel(
            id: page.id,
            index: page.index,
            asset: page.asset,
            displayDuration: page.displayDuration,
            liked: liked,
            viewed: page.viewed
        )

        var newPages = story.pages
        newPages[page.index] = newPage

        let newStory = StoryModel(
            id: story.id,
            user: story.user,
            index: story.index,
            viewed: story.viewed,
            postedAt: story.postedAt,
            pages: newPages
        )

        cachedStories[story.index] = newStory
        storeStories()

        return newStory
    }

    func loadStories() async -> [StoryModel] {
        if let storedStories = getStoriesFromPersistentStore() {
            cachedStories = storedStories
            return cachedStories
        } else {
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
            storeStories()

            return stories
        }
    }

    private func storeStories() {
        do {
            let data = try JSONEncoder().encode(cachedStories)
            persistentStore.set(data, forKey: Constant.storiesKey)
        } catch {
            // ..
        }
    }

    private func getStoriesFromPersistentStore() -> [StoryModel]? {
        guard let data = persistentStore.object(forKey: Constant.storiesKey) as? Data else { return nil }

        do {
            let stories = try JSONDecoder().decode([StoryModel].self, from: data)
            return stories
        } catch {
            return nil
        }
    }

    private func randomUrl() -> URL {
        URL(string: "https://picsum.photos/seed/\(UUID().uuidString)/1200/2400")!
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

private extension [StoryModel] {
    subscript(_ id: UUID) -> StoryModel? {
        first(where: { $0.id == id })
    }
}

private extension [PageModel] {
    subscript(_ id: UUID) -> PageModel? {
        first(where: { $0.id == id })
    }
}

struct ServiceDomain {
    
}
