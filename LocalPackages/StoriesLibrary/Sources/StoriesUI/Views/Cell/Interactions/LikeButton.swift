import SwiftUI

struct LikeButton: View {

    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    @State private var completionTask: Task<Void, any Error>?
    @State private var animating: Bool = false

    @Binding
    var liked: Bool
    let handler: () -> Void

    var body: some View {
        Button {
            animating.toggle()
            liked.toggle()
            triggerFeedback()
        } label: {
            PhaseAnimator(LikePhase.allCases, trigger: animating) { phase in
                ZStack {
                    Image(systemName: liked ? "heart.fill" : "heart")
                        .transaction({ t in
                            t.disablesAnimations = true
                            t.animation = nil
                        })
                        .foregroundStyle(liked ? .likedForegroundStyle : .unLikedForegroundStyle)
                        .opacity(liked ? 1 - phase.opacity : 1)
                        .scaleEffect(phase.backgroundScale(liked: liked))
                    Image(systemName: "heart.fill")
                        .opacity(liked ? 1 : phase.opacity)
                        .foregroundStyle(phase.foregroundStyle(liked: liked))
                        .offset(y: phase.verticalOffset(liked: liked))
                        .scaleEffect(phase.scale(liked: liked))
                        .rotationEffect(phase.rotation(liked: liked))
                }
                .onChange(of: phase) { _, newPhase in
                    triggerCompletionHandler(phase: newPhase)
                }
            } animation: { phase in
                phase.animation(liked: liked)
            }
        }
        .onAppear {
            feedbackGenerator.prepare()
        }
    }

    private func triggerCompletionHandler(phase: LikePhase) {
        if phase == .idle {
            completionTask = Task {
                try await Task.sleep(for: .seconds(phase.animationDuration(liked: liked)))
                handler()
            }
        } else {
            completionTask?.cancel()
        }
    }

    private func triggerFeedback() {
        guard liked else { return }
        feedbackGenerator.impactOccurred()
        feedbackGenerator.prepare()
    }
}

private extension View {

    @ViewBuilder
    func rotation(on: Bool, angle: Angle) -> some View {
        if on {
            self.rotationEffect(angle)
        }
    }
}

private enum LikePhase: CaseIterable {
    case idle
    case start
    case up
    case down

    var opacity: CGFloat {
        switch self {
            case .idle:
                0
            case .start:
                1
            case .up:
                1
            case .down:
                1
        }
    }

    func animationDuration(liked: Bool) -> TimeInterval {
        if liked {
            switch self {
                case .idle:
                    0.1
                case .start:
                    0.1
                case .up:
                    0.35
                case .down:
                    0.2
            }
        } else {
            switch self {
                case .idle:
                    0
                default:
                    0.3
            }
        }
    }

    func animation(liked: Bool) -> Animation {
        if liked {
            switch self {
                case .idle:
                        .linear(duration: animationDuration(liked: liked))
                case .start:
                        .linear(duration: animationDuration(liked: liked))
                case .up:
                        .smooth(duration: animationDuration(liked: liked))
                case .down:
                        .snappy(duration: animationDuration(liked: liked))
            }
        } else {
            .snappy(duration: animationDuration(liked: liked))
        }
    }

    func foregroundStyle(liked: Bool) -> LinearGradient {
        if liked {
            switch self {
                case .idle:
                    .likedForegroundStyle
                case .start:
                    .likedForegroundStyle
                case .up:
                    .likingForegroundStyle
                case .down:
                    .likedForegroundStyle
            }
        } else {
            .likedForegroundStyle
        }
    }

    func rotation(liked: Bool) -> Angle {
        if liked {
            Angle(degrees: 0)
        } else {
            switch self {
                case .idle:
                    Angle(degrees: 0)
                default:
                    Angle(degrees: 720)
            }
        }
    }

    func scale(liked: Bool) -> CGSize {
        if liked {
            switch self {
                case .idle:
                    CGSize(width: 1, height: 1)
                case .start:
                    CGSize(width: 1, height: 1)
                case .up:
                    CGSize(width: 2, height: 2)
                case .down:
                    CGSize(width: 1, height: 1)
            }
        } else {
            switch self {
                case .idle:
                    CGSize(width: 1, height: 1)
                default:
                    CGSize(width: 0, height: 0)
            }
        }
    }

    func backgroundScale(liked: Bool) -> CGSize {
        if liked {
            CGSize(width: 1, height: 1)
        } else {
            switch self {
                case .idle:
                    CGSize(width: 1, height: 1)
                case .start:
                    CGSize(width: 0.8, height: 0.8)
                case .up:
                    CGSize(width: 0.8, height: 0.8)
                case .down:
                    CGSize(width: 1, height: 1)
            }
        }
    }

    func verticalOffset(liked: Bool) -> CGFloat {
        if liked {
            switch self {
                case .idle:
                    0
                case .start:
                    0
                case .up:
                    -70
                case .down:
                    0
            }
        } else {
            0
        }
    }
}

#Preview {
    @Previewable @State var liked: Bool = false

    LikeButton(liked: $liked) {
        // ..
    }
    .font(.system(size: 32, weight: .medium))
    .buttonStyle(.plain)
}

private extension ShapeStyle where Self == LinearGradient {
    static var likedForegroundStyle: LinearGradient {
        LinearGradient(colors: [.red, .pink, .purple, .blue], startPoint: .bottomLeading, endPoint: .topTrailing)
    }

    static var likingForegroundStyle: LinearGradient {
        LinearGradient(colors: [.red, .pink, .orange], startPoint: .bottomLeading, endPoint: .topTrailing)
    }

    static var unLikedForegroundStyle: LinearGradient {
        LinearGradient(colors: [.white], startPoint: .bottomLeading, endPoint: .topTrailing)
    }
}
