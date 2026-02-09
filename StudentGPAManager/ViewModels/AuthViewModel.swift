import FirebaseAuth
import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorAlert: ErrorAlert?

    private let authService: AuthService
    private var listenerHandle: AuthStateDidChangeListenerHandle?

    init(authService: AuthService) {
        self.authService = authService
        listenerHandle = authService.addAuthStateDidChangeListener { [weak self] user in
            Task { @MainActor in
                self?.user = user
            }
        }
        user = Auth.auth().currentUser
    }

    deinit {
        if let handle = listenerHandle {
            authService.removeAuthStateDidChangeListener(handle)
        }
    }

    func login(email: String, password: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            user = try await authService.login(email: email, password: password)
        } catch {
            errorAlert = ErrorAlert(message: error.localizedDescription)
        }
    }

    func register(email: String, password: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            user = try await authService.register(email: email, password: password)
        } catch {
            errorAlert = ErrorAlert(message: error.localizedDescription)
        }
    }

    func logout() {
        do {
            try authService.logout()
            user = nil
        } catch {
            errorAlert = ErrorAlert(message: error.localizedDescription)
        }
    }
}
