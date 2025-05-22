import SwiftUI

package struct StoriesScreen: View {

    @StateObject private var viewModel = StoriesScreenViewModel()

    package init() {
        // ..
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
    StoriesScreen()
}
