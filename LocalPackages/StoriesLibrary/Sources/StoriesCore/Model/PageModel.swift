import Foundation

package struct PageModel: Sendable {
    package let id: UUID
    package let index: Int
    package let asset: AssetModel
    package let displayDuration: TimeInterval
    package let liked: Bool
    package let viewed: Bool

    package init(id: UUID, index: Int, asset: AssetModel, displayDuration: TimeInterval, liked: Bool, viewed: Bool) {
        self.id = id
        self.index = index
        self.asset = asset
        self.displayDuration = displayDuration
        self.liked = liked
        self.viewed = viewed
    }
}
