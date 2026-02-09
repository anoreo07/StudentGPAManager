import Foundation

@MainActor
final class NationalityViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var isLoading = false
    @Published var errorAlert: ErrorAlert?

    private let service: NationalityService

    init(service: NationalityService) {
        self.service = service
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await service.fetchCountries()
            countries = result.sorted { $0.name.common < $1.name.common }
        } catch {
            errorAlert = ErrorAlert(message: error.localizedDescription)
        }
    }
}
