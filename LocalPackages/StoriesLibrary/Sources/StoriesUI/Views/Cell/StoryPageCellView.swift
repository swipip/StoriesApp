import SwiftUI

struct StoryPageCellView: View {

    @EnvironmentObject private var assetLoader: AssetLoader
    @State private var image: Image?

    let page: StoryPageViewData

    var body: some View {
        GeometryReader { geometryProxy in
            if let image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
                    .clipped()
            } else {
                Rectangle()
                    .fill(.black.gradient)
                    .overlay {
                        ProgressView()
                            .controlSize(.regular)
                            .tint(.white)
                            .opacity(0.5)
                    }
            }
        }
        .contentShape(Rectangle())
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .task {
            do {
                image = try await assetLoader.loadAsset(for: page.asset)
            } catch {
                // ..
            }
        }
        .id(page.id)
    }
}

#Preview {
    StoryPageCellView(page: StoryPageViewData(
        id: UUID(),
        index: 0,
        asset: StoryPageAsset(id: UUID(), mediaUrl: URL(string: "https://picsum.photos/200")!),
        displayDuration: 8,
        liked: false))
}
