import Foundation

struct UserProfile: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var age: Int
    var nationality: String
    var gender: String
    var avatarURL: String
    var university: String

    static let empty = UserProfile(
        id: "",
        name: "",
        age: 18,
        nationality: "",
        gender: "",
        avatarURL: "",
        university: ""
    )
}
