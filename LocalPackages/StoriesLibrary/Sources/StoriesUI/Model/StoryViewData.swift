import Foundation

package struct StoryViewData: Identifiable, Hashable, Sendable {
    public let id: UUID
    let index: Int
    let user: UserViewData
    let pages: [StoryPageViewData]

    public init(id: UUID, index: Int, user: UserViewData, pages: [StoryPageViewData]) {
        self.id = id
        self.index = index
        self.user = user
        self.pages = pages
    }
}
