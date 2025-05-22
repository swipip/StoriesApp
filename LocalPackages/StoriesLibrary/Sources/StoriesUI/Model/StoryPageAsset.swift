import Foundation

package struct StoryPageAsset: Sendable, Hashable {
    let id: UUID
    let mediaUrl: URL

    package init(id: UUID, mediaUrl: URL) {
        self.id = id
        self.mediaUrl = mediaUrl
    }
}
