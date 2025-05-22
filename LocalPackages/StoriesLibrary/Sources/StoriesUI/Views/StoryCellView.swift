import SwiftUI

struct StoryCellView: View {

    let story: StoryViewData

    @State private var selectedPage: StoryPageViewData?

    var body: some View {
        VStack(spacing: .zero) {
            Color
                .gray
                .overlay {
                    Text("page \(selectedPage?.index ?? -1)")
                }
            InteractionsView()
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
        }
        .overlay(alignment: .top) {
            VStack(spacing: .zero) {
                StoriesVisualTimerView(selectedItem: $selectedPage, model: story.pages) {
                    // ..
                }
                .padding(8)
                UserView(user: story.user) {
                    // handle dismiss and other interactions
                }
                .padding(8)
            }
        }
        .background(.black)
        .onAppear {
            selectedPage = story.pages.first
        }
    }
}

extension StoryPageViewData: StoryTimeLineDisplayable {
    // ..
}

#Preview {
    StoryCellView(story: StoryViewData(
        id: UUID(),
        index: 0,
        user: UserViewData(
            id: UUID(),
            name: "username",
            avatarURL: nil,
            isApproved: true,
            communication: nil,
            postedSince: "22 h"),
        pages: [
            StoryPageViewData(id: UUID(), index: 0, asset: StoryPageAsset(id: UUID(), mediaUrl: URL(string: "www.google.com")!), displayDuration: 4, liked: false),
            StoryPageViewData(id: UUID(), index: 0, asset: StoryPageAsset(id: UUID(), mediaUrl: URL(string: "www.google.com")!), displayDuration: 4, liked: false),
            StoryPageViewData(id: UUID(), index: 0, asset: StoryPageAsset(id: UUID(), mediaUrl: URL(string: "www.google.com")!), displayDuration: 4, liked: false),
            StoryPageViewData(id: UUID(), index: 0, asset: StoryPageAsset(id: UUID(), mediaUrl: URL(string: "www.google.com")!), displayDuration: 4, liked: false)
        ])
    )
}
