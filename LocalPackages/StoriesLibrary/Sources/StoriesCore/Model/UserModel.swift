import Foundation

package struct UserModel: Identifiable, Sendable, Codable {
    package let id: UUID
    package let username: String
    package let profileImageURL: URL?
    package let isApproved: Bool
    package let communication: String?
    package let postedSince: String

    package init(id: UUID, username: String, profileImageURL: URL?, isApproved: Bool, communication: String?, postedSince: String) {
        self.id = id
        self.username = username
        self.profileImageURL = profileImageURL
        self.isApproved = isApproved
        self.communication = communication
        self.postedSince = postedSince
    }
}
