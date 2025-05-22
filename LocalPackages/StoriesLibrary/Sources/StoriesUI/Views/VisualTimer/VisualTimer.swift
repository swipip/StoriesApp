import SwiftUI

enum StoryPhase {
    case toWatch
    case seen
    case current
}

struct VisualTimer: View {

    let phase: StoryPhase
    let duration: TimeInterval
    let completion: () -> Void

    var body: some View {
        HStack(spacing: .zero) {
            IndicatorViewRepresentable(
                phase: phase,
                duration: duration) {
                    completion()
                }
        }
        .background(.white.opacity(0.3))
        .clipShape(Capsule())
    }
}

private enum AnimationPhase {
    case idle
    case paused
    case live
    case complete
}

@MainActor
private protocol AnimatingLoadingBarViewModelDelegate: AnyObject {
    func updateAnimationPhase(_ phase: AnimationPhase)
}

@MainActor
private final class AnimatingLoadingBarViewModel {

    weak var delegate: (any AnimatingLoadingBarViewModelDelegate)?

    private(set) var phase: AnimationPhase = .idle

    func startAnimation() {
        phase = .live
        delegate?.updateAnimationPhase(.live)
    }

    func pauseAnimation() {
        phase = .paused
        delegate?.updateAnimationPhase(.paused)
    }

    func completeAnimation() {
        phase = .complete
        delegate?.updateAnimationPhase(.complete)
    }

    func resetAnimation() {
        phase = .idle
        delegate?.updateAnimationPhase(.idle)
    }
}

private struct IndicatorViewRepresentable: UIViewControllerRepresentable {

    @Environment(\.paused) private var paused: Bool

    let phase: StoryPhase
    let duration: TimeInterval
    let completionHandler: () -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        AnimatingLoadingBar(viewModel: context.coordinator, duration: duration, completionHandler: completionHandler)
    }

    func updateUIViewController(_ viewController: UIViewController, context: Context) {
        switch phase {
            case .toWatch:
                context.coordinator.resetAnimation()
            case .seen:
                context.coordinator.completeAnimation()
            case .current:
                if paused {
                    context.coordinator.pauseAnimation()
                } else {
                    context.coordinator.startAnimation()
                }
        }
    }

    func makeCoordinator() -> AnimatingLoadingBarViewModel {
        AnimatingLoadingBarViewModel()
    }
}

@MainActor
private final class AnimatingLoadingBar: UIViewController, AnimatingLoadingBarViewModelDelegate {

    private lazy var gauge: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        return view
    }()

    private var animator: UIViewPropertyAnimator?
    private var widthConstraint: NSLayoutConstraint?
    private let viewModel: AnimatingLoadingBarViewModel
    private let completionHandler: () -> Void
    private let duration: TimeInterval

    private var observer: Any?
    private var maxWidth: CGFloat?

    init(viewModel: AnimatingLoadingBarViewModel, duration: TimeInterval, completionHandler: @escaping () -> Void) {
        self.viewModel = viewModel
        self.duration = duration
        self.completionHandler = completionHandler

        super.init(nibName: nil, bundle: nil)

        viewModel.delegate = self

        setUpBackground()
        setUpGauge()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        gauge.layer.cornerRadius = view.bounds.height / 2
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        maxWidth = view.frame.width

        setUpAnimator()
        updateAnimationPhase(viewModel.phase)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        observer = nil
        animator?.stopAnimation(true)
        animator = nil
        widthConstraint?.constant = 0
    }

    func updateAnimationPhase(_ phase: AnimationPhase) {
        switch phase {
            case .idle:
                animator?.fractionComplete = 0
                animator?.pauseAnimation()
            case .complete:
                animator?.fractionComplete = 1
                animator?.pauseAnimation()
            case .paused:
                animator?.pauseAnimation()
            case .live:
                if let fractionComplete = animator?.fractionComplete {
                    if fractionComplete >= 0.99 {
                        animator?.fractionComplete = 0
                    }
                }
                animator?.startAnimation()
        }
    }

    private func setUpAnimator() {
        animator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        animator?.pausesOnCompletion = true

        observer = animator?.observe(\.isRunning) { [weak self] animator, _ in
            Task { @MainActor in
                if animator.fractionComplete == 1, !animator.isRunning {
                    self?.completionHandler()
                }
            }
        }

        animator?.addAnimations { [weak self] in
            guard let self, let maxWidth else { return }
            widthConstraint?.constant = maxWidth
            view.layoutIfNeeded()
        }
    }

    private func setUpBackground() {
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(background)

        background.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        background.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        background.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setUpGauge() {
        gauge.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gauge)

        gauge.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gauge.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gauge.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        let trailing = gauge.trailingAnchor.constraint(equalTo: view.leadingAnchor)
        trailing.priority = .defaultLow
        trailing.isActive = true

        widthConstraint = gauge.widthAnchor.constraint(equalToConstant: 0)
        widthConstraint?.isActive = true
    }
}

#Preview {

    @Previewable @State var paused: Bool = false

    VisualTimer(phase: .current, duration: 5) {

    }
    .frame(height: 50)
    .padding()
    .background(.black)
    .onLongPressGesture {
        // ..
    } onPressingChanged: { pressed in
        paused = pressed
    }
    .environment(\.paused, paused)
}
