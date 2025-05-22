import SwiftUI

struct PrefetchScrollView<T: Identifiable & Hashable & Indexable & Sendable, Content: View>: View {

    enum PrefetchPolicy: Int {
        case conservative = 2
        case regular = 5
        case aggressive = 10
    }

    @Environment(\.willReachListEnd)
    private var willReachListEnd: () async -> Void

    @ObservedObject
    private var viewModel: PrefetchScrollViewModel<T>

    @Binding
    private var selectedItem: T?

    private let axis: Axis.Set
    private let content: (T) -> Content
    private let prefetch: @Sendable ([T]) async -> Void

    init(axis: Axis.Set,
         policy: PrefetchPolicy,
         model: [T],
         selectedItem: Binding<T?>,
         content: @escaping (T) -> Content,
         prefetch: @Sendable @escaping ([T]) async -> Void) {

        self.axis = axis
        self.content = content
        self.prefetch = prefetch
        self.viewModel = PrefetchScrollViewModel(model: model, prefetchCount: policy.rawValue)

        _selectedItem = selectedItem
    }

    var body: some View {
        ScrollView(axis, showsIndicators: false) {
            layout {
                ForEach(viewModel.model) { item in
                    content(item)
                        .id(item)
                        .task {
                            await prefetch(currentItem: item)
                            callWillReachEndIfNeeded(currentItem: item)
                        }
                }
                progressView
            }
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $selectedItem)
    }

    @ViewBuilder
    private func layout(@ViewBuilder content: () -> some View) -> some View {
        switch axis {
            case .horizontal:
                LazyHStack(spacing: .zero) {
                    content()
                }
                .scrollTargetLayout()
            case .vertical:
                LazyVStack(spacing: .zero) {
                    content()
                }
                .scrollTargetLayout()
            default:
                EmptyView()
        }
    }

    @ViewBuilder
    var progressView: some View {
        if viewModel.reloadTaskIsRunning {
            ProgressView()
                .controlSize(.large)
                .padding()
        }
    }

    private func prefetch(currentItem: T) async {
        let range = viewModel.prefetchRange(currentItem: currentItem)
        await prefetch(range)
    }

    private func callWillReachEndIfNeeded(currentItem: T) {
        viewModel.callWillReachEndIfNeeded(currentItem: currentItem) {
            await willReachListEnd()
        }
    }
}

