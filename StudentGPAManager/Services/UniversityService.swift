import Foundation

final class UniversityService {
    func fetchUniversities(country: String) async throws -> [University] {
        let encoded = country.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? country
        let urlString = "http://universities.hipolabs.com/search?country=\(encoded)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([University].self, from: data)
    }
}
