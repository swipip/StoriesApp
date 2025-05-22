import Foundation

@MainActor
final class PrefetchScrollViewModel<T: Identifiable & Hashable & Indexable>: ObservableObject {

    @Published private(set) var reloadTaskIsRunning: Bool = false

    let model: [T]
    let prefetchCount: Int

    init(model: [T], prefetchCount: Int) {
        self.model = model
        self.prefetchCount = prefetchCount
    }

    func prefetchRange(currentItem: T) -> [T] {
        let upperBound = min(currentItem.index + prefetchCount, model.count - 1)
        return Array(model[currentItem.index ..< upperBound])
    }

    func callWillReachEndIfNeeded(currentItem: T, _ handler: @escaping () async -> Void) {
        guard !reloadTaskIsRunning, currentItem.index == model.count - prefetchCount else { return }

        reloadTaskIsRunning = true
        Task {
            await handler()
            reloadTaskIsRunning = false
        }
    }
}
