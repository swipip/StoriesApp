import SwiftUI

protocol Indexable {
    var index: Int { get }
}

struct PagesSelectionButtonsOverlayView<T: Indexable>: View {

    enum Action {
        case requestPrevious
        case finishedWatching
    }

    @State private var animateBackground: Bool = true

    let pages: [T]
    @Binding var selectedPage: T?
    let handler: (Action) -> Void

    var body: some View {
        HStack(spacing: .zero) {
            gradient
                .phaseAnimator([0, 1], trigger: animateBackground) { view, phase in
                    view.opacity(phase == 0 ? 0.01 : 1)
                } animation: { phase in
                    if phase == 0 {
                        .easeOut(duration: 0.2)
                    } else {
                        .linear(duration: 0)
                    }
                }
                .onTapGesture {
                    animateBackground.toggle()
                    selectPreviousPage()
                }
            gradient
                .opacity(0.01)
                .scaleEffect(x: -1, y: 1)
                .onTapGesture {
                    selectNextPage()
                }
        }
    }

    private var gradient: some View {
        LinearGradient(
            colors: [
                .black.opacity(0.1),
                .black.opacity(0.05),
                .black.opacity(0),
                .black.opacity(0)
            ],
            startPoint: .leading,
            endPoint: .trailing)
    }

    private func selectNextPage() {
        guard let selectedPage else { return }
        if let nextPage = pages.first(where: { $0.index > selectedPage.index }) {
            self.selectedPage = nextPage
        } else {
            handler(.finishedWatching)
        }
    }

    private func selectPreviousPage() {
        guard let selectedPage else { return }
        let previousIndex = selectedPage.index - 1

        if let previousPage = pages.first(where: { $0.index == previousIndex }) {
            self.selectedPage = previousPage
        } else {
            handler(.requestPrevious)
        }
    }
}
