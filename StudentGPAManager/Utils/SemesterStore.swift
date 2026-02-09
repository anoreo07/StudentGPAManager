import Foundation

final class SemesterStore {
    private let key = "semesters_data"

    func save(_ semesters: [Semester]) {
        guard let data = try? JSONEncoder().encode(semesters) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    func load() -> [Semester] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let semesters = try? JSONDecoder().decode([Semester].self, from: data) else {
            return []
        }
        return semesters
    }
}
