import SwiftUI

struct StoriesVisualTimerView<T: StoryTimeLineDisplayable>: View {

    @Environment(\.selected) private var selected: Bool

    @Binding
    var selectedItem: T?
    let model: [T]
    let onTimerComplete: () -> Void

    var body: some View {
        HStack(spacing: 2) {
            ForEach(model) { item in
                VisualTimer(phase: storyPhase(for: item), duration: item.displayDuration) {
                    selectNextItem()
                }
            }
        }
        .frame(height: 2)
    }

    private func selectNextItem() {
        guard let selectedItem else { return }
        if let candidate = model.first(where: { $0.index > selectedItem.index }) {
            self.selectedItem = candidate
        } else {
            onTimerComplete()
        }
    }

    private func storyPhase(for currentItem: T) -> StoryPhase {
        guard let selectedItem else { return .toWatch }
        if !selected {
            return .toWatch
        } else if selectedItem.id == currentItem.id {
            return .current
        } else if selectedItem.index >= currentItem.index {
            return .seen
        } else {
            return .toWatch
        }
    }
}

#Preview {

    @MainActor
    struct Previewer: View {

        struct Item: StoryTimeLineDisplayable {
            var index: Int
            var displayDuration: TimeInterval
            var id: Int
        }

        let model: [Item]
        @State private var selectedItem: Item?

        init() {
            let items = [
                Item(index: 0, displayDuration: 2, id: 1),
                Item(index: 1, displayDuration: 2, id: 2),
                Item(index: 2, displayDuration: 2, id: 3)
            ]
            model = items
            _selectedItem = .init(initialValue: items[0])
        }

        var body: some View {
            StoriesVisualTimerView(selectedItem: $selectedItem, model: model, onTimerComplete: {
                // ..
            })
            .onChange(of: selectedItem?.id) { _, _ in
                   // ..
                }
                .padding()
                .background(.black)
        }
    }

    return Previewer()
}
