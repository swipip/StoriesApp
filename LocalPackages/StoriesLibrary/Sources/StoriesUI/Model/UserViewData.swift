import Foundation

package struct UserViewData: Hashable, Sendable {
    let id: UUID
    let name: String
    let avatarURL: URL?
    let isApproved: Bool
    let communication: String?
    let postedSince: String

    package init(id: UUID, name: String, avatarURL: URL?, isApproved: Bool, communication: String?, postedSince: String) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
        self.isApproved = isApproved
        self.communication = communication
        self.postedSince = postedSince
    }
}
