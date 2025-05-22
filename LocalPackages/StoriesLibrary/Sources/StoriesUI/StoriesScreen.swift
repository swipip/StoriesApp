import SwiftUI

package struct StoriesScreen: View {

    @StateObject private var viewModel = StoriesScreenViewModel()

    package var body: some View {
        Scroll3DView(selectedItem: $viewModel.selectedStory, items: viewModel.stories) { story in
            StoryCellView(story: story)
                .containerRelativeFrame(.horizontal)
                .overlay {
                    Text("\(story.index)")
                }
        }
        .background(.black)
    }

}

#Preview {
    StoriesScreen()
}
