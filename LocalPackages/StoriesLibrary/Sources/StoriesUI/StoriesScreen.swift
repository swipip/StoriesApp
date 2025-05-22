import SwiftUI

package struct StoriesScreen: View {

    @StateObject private var viewModel = StoriesScreenViewModel()

    package var body: some View {
        Scroll3DView(selectedItem: $viewModel.selectedStory, items: viewModel.stories) { story in
            Color
                .blue
                .containerRelativeFrame(.horizontal)
                .overlay {
                    Text("\(story.index)")
                }
        }
    }

}

#Preview {
    StoriesScreen()
}
