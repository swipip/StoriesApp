import Foundation

protocol StoryTimeLineDisplayable: Identifiable {
    var index: Int { get }
    var displayDuration: TimeInterval { get }
}
