import SwiftUI

package struct StoriesListView: View {

    @StateObject private var assetLoader = AssetLoader.shared
    @StateObject private var viewModel: StoriesListViewModel

    private let handler: (_ storyId: UUID) -> Void

    package init(provider: some StoriesProvider, handler: @escaping (_ storyId: UUID) -> Void) {
        _viewModel = .init(wrappedValue: StoriesListViewModel(provider: provider))
        self.handler = handler
    }

    package var body: some View {
        PrefetchScrollView(axis: .horizontal, policy: .aggressive, model: viewModel.stories, selectedItem: $viewModel.selectedStory) { item in
            StoriesListCell(story: item) {
                handler(item.id)
            }
        } prefetch: { prefetchingRange in
            await prefetchStories(prefetchingRange)
        }
        .environmentObject(assetLoader)
        .task {
            await viewModel.load()
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

            func setStoryLiked(liked: Bool, storyId: UUID, pageId: UUID) async throws {
                // ..
            }

            func loadStories() async throws -> [StoryViewData] {
                [
                    StoryViewData(id: UUID(), index: 0, user: user, pages: [
                        StoryPageViewData(id: UUID(), index: 0, asset: media, displayDuration: 3, liked: false),
                    ]),
                    StoryViewData(id: UUID(), index: 1, user: user, pages: [
                        StoryPageViewData(id: UUID(), index: 0, asset: media, displayDuration: 8, liked: false),
                    ]),
                    StoryViewData(id: UUID(), index: 2, user: user, pages: [
                        StoryPageViewData(id: UUID(), index: 0, asset: media, displayDuration: 8, liked: false),
                    ]),
                    StoryViewData(id: UUID(), index: 3, user: user, pages: [
                        StoryPageViewData(id: UUID(), index: 0, asset: media, displayDuration: 8, liked: false),
                    ]),
                    StoryViewData(id: UUID(), index: 4, user: user, pages: [
                        StoryPageViewData(id: UUID(), index: 0, asset: media, displayDuration: 8, liked: false),
                    ]),
                    StoryViewData(id: UUID(), index: 5, user: user, pages: [
                        StoryPageViewData(id: UUID(), index: 0, asset: media, displayDuration: 8, liked: false),
                    ]),
                    StoryViewData(id: UUID(), index: 6, user: user, pages: [
                        StoryPageViewData(id: UUID(), index: 0, asset: media, displayDuration: 8, liked: false),
                    ])
                ]
            }
        }

        private let provider = Provider()

        var body: some View {
            StoriesListView(provider: provider) { _ in
                // ..
            }
        }
    }

    return Previewer()
}
