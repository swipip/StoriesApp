import SwiftUI

package struct StoriesScreen: View {

    @StateObject private var assetLoader = AssetLoader()
    @StateObject private var viewModel: StoriesScreenViewModel

    private let onFinishedWatching: () -> Void

    package init(provider: some StoriesProvider, onFinishedWatching: @escaping () -> Void) {
        _viewModel = .init(wrappedValue: StoriesScreenViewModel(provider: provider))
        self.onFinishedWatching = onFinishedWatching
    }

    package var body: some View {
        Scroll3DView(selectedItem: $viewModel.selectedStory, items: viewModel.stories) { story in
            StoryCellView(story: story, handler: handleStoryCellAction(_:))
        } prefetch: { prefetchItems in
            await prefetchStories(prefetchItems)
        }
        .background(.black)
        .environmentObject(assetLoader)
        .task {
            await viewModel.load()
        }
    }

    private func handleStoryCellAction(_ action: StoryCellView.Action) {
        switch action {
            case .finishedWatching:
                withAnimation {
                    viewModel.selectNextStory {
                        onFinishedWatching()
                    }
                }
            case .requestPrevious:
                withAnimation {
                    viewModel.selectPreviousStory()
                }
            case .close:
                onFinishedWatching()
        }
    }

    private func prefetchStories(_ prefetchItems: [StoryViewData]) async {
        let assets = prefetchItems.flatMap(\.pages).map(\.asset)
        do {
            try await assetLoader.preloadAssets(for: assets)
        } catch {
            // ..
        }
    }
}

extension StoryViewData: Indexable {
    // ..
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
            StoriesScreen(provider: provider) {
                // ..
            }
        }
    }

    return Previewer()
}
