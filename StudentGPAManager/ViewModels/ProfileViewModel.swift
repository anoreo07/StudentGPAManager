import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile = UserProfile.empty
    @Published var isLoading = false
    @Published var errorAlert: ErrorAlert?

    private let userService: UserService
    private let userIdProvider: () -> String?

    init(userService: UserService, userIdProvider: @escaping () -> String?) {
        self.userService = userService
        self.userIdProvider = userIdProvider
    }

    func loadProfile() async {
        guard let userId = userIdProvider() else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            if let loaded = try await userService.fetchProfile(userId: userId) {
                profile = loaded
            } else {
                profile.id = userId
            }
        } catch {
            errorAlert = ErrorAlert(message: error.localizedDescription)
        }
    }

    func saveProfile() async {
        guard let userId = userIdProvider() else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            profile.id = userId
            try await userService.saveProfile(profile)
        } catch {
            errorAlert = ErrorAlert(message: error.localizedDescription)
        }
    }
}
