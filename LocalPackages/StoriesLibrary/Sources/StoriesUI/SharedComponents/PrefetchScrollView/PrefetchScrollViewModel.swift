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
}
