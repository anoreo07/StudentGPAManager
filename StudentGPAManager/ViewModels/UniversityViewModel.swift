import Foundation

@MainActor
final class UniversityViewModel: ObservableObject {
    @Published var universities: [University] = []
    @Published var isLoading = false
    @Published var errorAlert: ErrorAlert?

    private let service: UniversityService

    init(service: UniversityService) {
        self.service = service
    }

    func load(country: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            universities = try await service.fetchUniversities(country: country)
        } catch {
            errorAlert = ErrorAlert(message: error.localizedDescription)
        }
    }
}
