import Foundation

@MainActor
final class StoriesScreenViewModel: ObservableObject {

    private static let media = StoryPageAsset(id: UUID(), mediaUrl: URL(string: "https://picsum.photos/200")!)
    private static let user = UserViewData(
        id: UUID(),
        name: "username",
        avatarURL: nil,
        isApproved: true,
        communication: "communication commerciale avec **Lululemon**",
        postedSince: "22 h"
    )

    @Published var selectedStory: StoryViewData?
    @Published var stories: [StoryViewData] = [
        StoryViewData(id: UUID(), index: 0, user: user, pages: [
            StoryPageViewData(id: UUID(), index: 0, asset: media, displayDuration: 3, liked: false),
            StoryPageViewData(id: UUID(), index: 1, asset: media, displayDuration: 4, liked: false),
            StoryPageViewData(id: UUID(), index: 2, asset: media, displayDuration: 8, liked: false),
            StoryPageViewData(id: UUID(), index: 3, asset: media, displayDuration: 4, liked: false)
        ]),
        StoryViewData(id: UUID(), index: 1, user: user, pages: [
            StoryPageViewData(id: UUID(), index: 0, asset: media, displayDuration: 8, liked: false),
            StoryPageViewData(id: UUID(), index: 1, asset: media, displayDuration: 10, liked: false),
            StoryPageViewData(id: UUID(), index: 2, asset: media, displayDuration: 4, liked: false),
            StoryPageViewData(id: UUID(), index: 3, asset: media, displayDuration: 4, liked: false)
        ])
    ]

    init() {
        // ..
    }
}
