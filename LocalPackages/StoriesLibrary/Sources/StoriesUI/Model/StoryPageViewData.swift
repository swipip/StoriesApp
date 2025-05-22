import Foundation

package struct StoryPageViewData: Identifiable, Hashable, Sendable {
    package let id: UUID
    let index: Int
    let asset: StoryPageAsset
    let displayDuration: TimeInterval
    let liked: Bool

    package init(id: UUID, index: Int, asset: StoryPageAsset, displayDuration: TimeInterval, liked: Bool) {
        self.id = id
        self.index = index
        self.asset = asset
        self.displayDuration = displayDuration
        self.liked = liked
    }
}
