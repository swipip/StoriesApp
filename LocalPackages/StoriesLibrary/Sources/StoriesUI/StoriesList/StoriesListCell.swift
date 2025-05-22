import SwiftUI

struct StoriesListCell: View {

    @EnvironmentObject private var assetLoader: AssetLoader

    @State private var image: Image?

    let story: StoryViewData
    let handler: () -> Void

    var body: some View {
        Circle()
            .stroke(LinearGradient(colors: [.orange, .red, .pink], startPoint: .bottomLeading, endPoint: .topTrailing), lineWidth: 3)
            .frame(height: 80)
            .padding(3)
            .overlay {
                if let image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 74, height: 74)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(.gray.opacity(0.4).gradient)
                        .padding(6)
                }

            }
            .onTapGesture {
                handler()
            }
            .task {
                guard let asset = story.pages.first?.asset else { return }
                do {
                    image = try await assetLoader.loadAsset(for: asset)
                } catch {
                    // ..
                }
            }
    }
}

#Preview {
    StoriesListCell(story: StoryViewData(id: UUID(), index: 0, user: UserViewData(id: UUID(), name: "", avatarURL: nil, isApproved: true, communication: nil, postedSince: ""), pages: [])) {
        // ..
    }
    .environmentObject(AssetLoader.shared)
}
