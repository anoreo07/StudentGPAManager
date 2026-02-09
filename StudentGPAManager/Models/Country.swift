import Foundation

struct Country: Identifiable, Decodable, Equatable {
    struct Name: Decodable, Equatable {
        let common: String
    }

    let id: UUID
    let name: Name

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(Name.self, forKey: .name)
        id = UUID()
    }

    enum CodingKeys: String, CodingKey {
        case name
    }
}
