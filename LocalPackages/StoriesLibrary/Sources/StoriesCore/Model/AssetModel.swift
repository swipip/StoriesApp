import Foundation

package struct AssetModel: Sendable, Codable {
    package let id: UUID
    package let mediaUrl: URL

    package init(id: UUID, mediaUrl: URL) {
        self.id = UUID()
        self.mediaUrl = mediaUrl
    }
}
