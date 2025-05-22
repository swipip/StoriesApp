import SwiftUI

struct InteractionsView: View {

    @State private var editingText = ""

    var body: some View {
        HStack(spacing: 10) {
            TextField("", text: $editingText, prompt: Text(verbatim: "Envoyer un message").foregroundStyle(.white.opacity(0.8)))
                .foregroundStyle(.white)
                .font(.callout)
                .padding(.horizontal, 18)
                .frame(height: 44)
                .background {
                    Capsule()
                        .stroke(.white.opacity(0.4))
                        .shadow(radius: 6)
                }

            Button {
                // ..
            } label: {
                Image(systemName: "heart")
            }

            Button {
                // ..
            } label: {
                Image(systemName: "paperplane")
            }
        }
        .font(.system(size: 22, weight: .medium))
        .foregroundStyle(.white)
    }
}

#Preview {
    InteractionsView()
        .padding()
        .background(.black)
}
