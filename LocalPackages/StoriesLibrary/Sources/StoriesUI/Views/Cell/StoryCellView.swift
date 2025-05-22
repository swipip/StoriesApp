import SwiftUI

struct StoryCellView: View {

    let story: StoryViewData

    @State private var hideAccessories: Bool = false
    @State private var paused: Bool = false
    @State private var selectedPage: StoryPageViewData?

    var body: some View {
        VStack(spacing: .zero) {
            ScrollView(.horizontal) {
                LazyHStack(spacing: .zero) {
                    ForEach(story.pages) { page in
                        StoryPageCellView(page: page)
                            .containerRelativeFrame(.horizontal)
                            .id(page)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $selectedPage)
            .scrollDisabled(true)

            InteractionsView()
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
                .opacity(hideAccessories ? 0 : 1)
        }
        .overlay {
            PagesSelectionButtonsOverlayView(pages: story.pages, selectedPage: $selectedPage) { action in
                guard !paused else { return }
                switch action {
                    case .requestPrevious:
                        break
                    case .finishedWatching:
                        break
                }
            }
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
            .opacity(hideAccessories ? 0 : 1)
        }
        .background(.black)
        .animation(hideAccessories ? .snappy(duration: 0.2) : .smooth, value: hideAccessories)
        .onExtraLongPress(limit: 0.5, pressed: $paused, extraLongPressed: $hideAccessories)
        .environment(\.paused, paused)
        .onAppear {
            selectedPage = story.pages.first
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
    )
}
