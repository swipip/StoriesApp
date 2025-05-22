import SwiftUI
import Stories

struct MainScreen: View {

    @State private var selectedStory: SelectedStory?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: .zero) {
                StoriesListView { tappedStory in
                    selectedStory = tappedStory
                }
                Text("FEED")
            }
        }
        .fullScreenCover(item: $selectedStory) { story in
            StoriesScreen()
        }
    }
}

#Preview {
    MainScreen()
}
