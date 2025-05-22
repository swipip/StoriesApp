import SwiftUI

struct StoryPageCellView: View {

    let page: StoryPageViewData

    var body: some View {
        GeometryReader { geometryProxy in
            AsyncImage(url: page.asset.mediaUrl) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
                    .clipped()
            } placeholder: {
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
