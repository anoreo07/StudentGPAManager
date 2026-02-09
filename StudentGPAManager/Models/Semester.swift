import Foundation

struct Semester: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var courses: [Course]

    init(id: UUID = UUID(), name: String, courses: [Course] = []) {
        self.id = id
        self.name = name
        self.courses = courses
    }
}
