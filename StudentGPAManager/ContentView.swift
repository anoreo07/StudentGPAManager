import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.user != nil {
                MainTabView()
            } else {
                AuthFlowView()
            }
        }
    }
}

#Preview {
    ContentView()
}
