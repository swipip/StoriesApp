import SwiftUI

package struct StoriesScreen: View {

    @StateObject private var viewModel: StoriesScreenViewModel

    package init(provider: some StoriesProvider) {
        _viewModel = .init(wrappedValue: StoriesScreenViewModel(provider: provider))
    }

    package var body: some View {
        Scroll3DView(selectedItem: $viewModel.selectedStory, items: viewModel.stories) { story in
            StoryCellView(story: story)
        }
        .background(.black)
        .task {
            await viewModel.load()
        }
    }

}

#Preview {

    @MainActor
    struct Previewer: View {

        final class Provider: StoriesProvider {

            private let media = StoryPageAsset(id: UUID(), mediaUrl: URL(string: "https://picsum.photos/200")!)
            private let user = UserViewData(
                id: UUID(),
                name: "username",
                avatarURL: nil,
                isApproved: true,
                communication: "communication commerciale avec **Lululemon**",
                postedSince: "22 h"
            )

            func loadStories() async throws -> [StoryViewData] {
                [
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
            }
        }

        private let provider = Provider()

        var body: some View {
            StoriesScreen(provider: provider)
        }
    }

    return Previewer()
}
