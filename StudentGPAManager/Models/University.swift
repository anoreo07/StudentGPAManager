import Foundation

struct University: Identifiable, Decodable, Equatable {
    let id: UUID
    let name: String
    let country: String
    let webPages: [String]

    enum CodingKeys: String, CodingKey {
        case name
        case country
        case webPages = "web_pages"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        country = try container.decode(String.self, forKey: .country)
        webPages = try container.decode([String].self, forKey: .webPages)
        id = UUID()
    }
}
