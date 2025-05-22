import SwiftUI

private struct LongPressModifier: ViewModifier {

    @State private var extraLongPressTask: Task<Void, any Error>?

    let limit: TimeInterval

    @Binding var pressed: Bool
    @Binding var extraLongPressed: Bool

    func body(content: Content) -> some View {
        content
            .onLongPressGesture {
                // ..
            } onPressingChanged: { pressed in
                self.pressed = pressed

                if !pressed {
                    extraLongPressTask?.cancel()
                    extraLongPressed = false
                } else {
                    triggerExtraLongPress()
                }
            }
    }

    private func triggerExtraLongPress() {
        extraLongPressTask = Task {
            try await Task.sleep(for: .milliseconds(500))
            try Task.checkCancellation()

            extraLongPressed = true
        }
    }
}

extension View {
    func onExtraLongPress(limit: TimeInterval, pressed: Binding<Bool>, extraLongPressed: Binding<Bool>) -> some View {
        self.modifier(LongPressModifier(limit: limit, pressed: pressed, extraLongPressed: extraLongPressed))
    }
}
