import SwiftUI

package struct StoriesScreen: View {

    package var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: .zero) {
                Color
                    .blue
                    .containerRelativeFrame(.horizontal)

                Color
                    .green
                    .containerRelativeFrame(.horizontal)
            }
        }
    }

}

#Preview {
    StoriesScreen()
}
