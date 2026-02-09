import Foundation

struct Course: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var credits: Int
    var grade: Double

    init(id: UUID = UUID(), name: String, credits: Int, grade: Double) {
        self.id = id
        self.name = name
        self.credits = credits
        self.grade = grade
    }
}
