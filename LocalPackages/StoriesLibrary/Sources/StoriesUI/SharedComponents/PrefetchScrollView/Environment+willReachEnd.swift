import SwiftUI

extension EnvironmentValues {
    @Entry var willReachListEnd: () async -> Void = { }
}

extension View {
    func onListWillReachEnd(_ handler: @escaping () async -> Void) -> some View {
        self.environment(\.willReachListEnd, handler)
    }
}
