import Foundation

final class NationalityService {
    func fetchCountries() async throws -> [Country] {
        guard let url = URL(string: "https://restcountries.com/v3.1/all") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Country].self, from: data)
    }
}
