import Foundation

package struct StoryModel: Sendable, Codable {
    package let id: UUID
    package let user: UserModel
    package let index: Int
    package let viewed: Bool
    package let postedAt: Date
    package let pages: [PageModel]

    package init(id: UUID, user: UserModel, index: Int, viewed: Bool, postedAt: Date, pages: [PageModel]) {
        self.id = id
        self.user = user
        self.index = index
        self.viewed = viewed
        self.postedAt = postedAt
        self.pages = pages
    }
}
