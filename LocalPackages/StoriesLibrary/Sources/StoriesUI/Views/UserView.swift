import SwiftUI

struct UserView: View {

    private enum Constant {
        static let height: CGFloat = 30
    }

    let user: UserViewData
    let handler: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: user.avatarURL) { image in
                image
                    .interpolation(.low)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constant.height, height: Constant.height)
            } placeholder: {
                Circle()
                    .fill(.gray.gradient)
                    .frame(width: Constant.height, height: Constant.height)
            }
            .overlay(Color.black.opacity(0.35))
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 4) {
                    Text(user.name)
                        .fontWeight(.bold)
                    if user.isApproved {
                        Image(systemName: "seal.fill")
                            .font(.caption)
                            .maskOut {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 6, weight: .black))
                            }
                    }
                    Text(user.postedSince)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.leading, 6)
                }
                if let communication = user.communication,
                   let formattedString = try? AttributedString(markdown: communication) {
                    Text(formattedString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()

            Group {
                Button {
                    // ..
                } label: {
                    Image(systemName: "ellipsis")
                        .fontWeight(.light)
                }
                .buttonStyle(.plain)

                Button {
                    handler()
                } label: {
                    Image(systemName: "xmark")
                        .fontWeight(.light)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .font(.title2)
        }
        .font(.subheadline)
        .frame(height: Constant.height)
        .foregroundStyle(.primary)
        .preferredColorScheme(.dark)
    }
}

private extension View {

    @ViewBuilder func maskOut<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask {
            Rectangle()
                .overlay(alignment: alignment) {
                    mask()
                        .blendMode(.destinationOut)
                }
        }
    }
}

#Preview {
    UserView(
        user: UserViewData(
            id: UUID(),
            name: "username",
            avatarURL: nil,
            isApproved: true,
            communication: "communication commerciale avec **Lululemon**",
            postedSince: "22 h"
        )
    ) {
        // ..
    }
    .padding()
}
