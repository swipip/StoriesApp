import SwiftUI

struct StoryCellView: View {

    enum Action {
        case close
        case finishedWatching
        case requestPrevious
        case likedButtonPressed(liked: Bool, page: StoryPageViewData)
    }

    let story: StoryViewData
    let handler: (Action) -> Void

    @EnvironmentObject private var assetLoader: AssetLoader

    @State private var hideAccessories: Bool = false
    @State private var paused: Bool = false
    @State private var selectedPage: StoryPageViewData?
    @State private var like: Bool = false
    @State private var stateFullPages: [StoryPageViewData] = []

    var body: some View {
        VStack(spacing: .zero) {
            PrefetchScrollView(axis: .horizontal, policy: .aggressive, model: stateFullPages, selectedItem: $selectedPage) { page in
                StoryPageCellView(page: page, onReady: {
                    if selectedPage == nil {
                        selectedPage = page
                    }
                })
                .containerRelativeFrame(.horizontal)
                .id(page)
            } prefetch: { prefetchingItems in
                await prefetchAssets(for: prefetchingItems)
            }
            .scrollDisabled(true)
            .overlay {
                PagesSelectionButtonsOverlayView(pages: stateFullPages, selectedPage: $selectedPage) { action in
                    guard !paused else { return }
                    switch action {
                        case .requestPrevious:
                            handler(.requestPrevious)
                        case .finishedWatching:
                            handler(.finishedWatching)
                    }
                }
            }
            .overlay(alignment: .top) {
                VStack(spacing: .zero) {
                    StoriesVisualTimerView(selectedItem: $selectedPage, model: stateFullPages) {
                        // ..
                    }
                    .padding(8)
                    UserView(user: story.user) {
                        handler(.close)
                    }
                    .padding(8)
                }
                .opacity(hideAccessories ? 0 : 1)
            }

            InteractionsView(liked: Binding(get: { selectedPage?.liked ?? false }, set: { handleLike(liked: $0) }))
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
                .opacity(hideAccessories ? 0 : 1)
        }
        .background(.black)
        .animation(hideAccessories ? .snappy(duration: 0.2) : .smooth, value: hideAccessories)
        .onExtraLongPress(limit: 0.5, pressed: $paused, extraLongPressed: $hideAccessories)
        .onAppear { stateFullPages = story.pages }
        .environment(\.paused, paused)
    }

    private func handleLike(liked: Bool) {
        guard let selectedPage else { return }
        updatePage(liked: liked)
        handler(.likedButtonPressed(liked: liked, page: selectedPage))
    }

    private func updatePage(liked: Bool) {
        guard let selectedPage else { return }
        let updatingPage = StoryPageViewData(id: selectedPage.id, index: selectedPage.index, asset: selectedPage.asset, displayDuration: selectedPage.displayDuration, liked: liked)
        self.selectedPage = updatingPage
        stateFullPages[selectedPage.index] = updatingPage
    }

    private func prefetchAssets(for items: [StoryPageViewData]) async {
        do {
            try await assetLoader.preloadAssets(for: items.map(\.asset))
        } catch {
            // ..
        }
    }
}

extension EnvironmentValues {
    @Entry var paused: Bool = false
}

extension StoryPageViewData: StoryTimeLineDisplayable, Indexable {
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
    ) { _ in
        // ..
    }
}
