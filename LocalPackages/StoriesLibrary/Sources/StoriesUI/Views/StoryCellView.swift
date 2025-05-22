import SwiftUI

struct StoryCellView: View {

    let story: StoryViewData

    var body: some View {
        VStack(spacing: .zero) {
            Color
                .blue
            InteractionsView()
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
        }
        .overlay(alignment: .top) {
            UserView(user: story.user) {
                // handle dismiss and other interactions
            }
            .padding(8)
        }
        .background(.black)
    }
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
        pages: [])
    )
}
