import SwiftUI

struct Scroll3DView<T: Hashable & Identifiable & Sendable & Indexable, Content: View>: View {

    @Binding
    var selectedItem: T?
    let items: [T]
    let content: (T) -> Content
    let prefetch: @Sendable ([T]) async -> Void

    var body: some View {
        PrefetchScrollView(axis: .horizontal, policy: .regular, model: items, selectedItem: $selectedItem) { item in
            content(item)
                .containerRelativeFrame(.horizontal)
                .scrollTransition { effect, phase in
                    effect
                        .rotation3DEffect(
                            Angle(degrees: angle(for: phase)),
                            axis: (0, 1, 0),
                            anchor: anchorPoint(for: phase),
                            perspective: 1)
                }
                .id(item)
                .environment(\.selected, selectedItem == item)
        } prefetch: { prefetchRange in
            await prefetch(prefetchRange)
        }
    }

    nonisolated private func angle(for phase: ScrollTransitionPhase) -> Double {
        switch phase {
            case .bottomTrailing: 45
            case .topLeading: -45
            default: 0.0
        }
    }

    nonisolated private func anchorPoint(for phase: ScrollTransitionPhase) -> UnitPoint {
        switch phase {
            case .bottomTrailing: UnitPoint(x: 0, y: 0.5)
            case .topLeading: UnitPoint(x: 1, y: 0.5)
            default: UnitPoint(x: 0.5, y: 0.5)
        }
    }
}
