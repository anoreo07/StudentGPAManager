import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    Section("Transcript") {
                        NavigationLink {
                            TranscriptView()
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.blue)
                                Text("View & Export Transcript")
                            }
                        }
                    }

                    Section("Account") {
                        Button("Logout", role: .destructive) {
                            authViewModel.logout()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
