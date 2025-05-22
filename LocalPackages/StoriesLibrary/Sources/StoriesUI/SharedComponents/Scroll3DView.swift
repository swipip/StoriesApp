import SwiftUI

struct Scroll3DView<T: Hashable & Identifiable & Sendable, Content: View>: View {

    @Binding
    var selectedItem: T?
    let items: [T]
    let content: (T) -> Content

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: .zero) {
                ForEach(items) { item in
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
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $selectedItem)
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

extension EnvironmentValues {
    @Entry var paused: Bool = false
}
