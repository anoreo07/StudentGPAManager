import Foundation

@MainActor
final class SemestersViewModel: ObservableObject {
    @Published var semesters: [Semester] = [] {
        didSet {
            store.save(semesters)
        }
    }

    private let gpaService: GPAService
    private let store: SemesterStore

    init(gpaService: GPAService, store: SemesterStore) {
        self.gpaService = gpaService
        self.store = store
        semesters = store.load()
    }

    func addSemester(name: String) {
        let semester = Semester(name: name)
        semesters.append(semester)
    }

    func deleteSemester(at offsets: IndexSet) {
        semesters.remove(atOffsets: offsets)
    }

    func semester(for id: UUID) -> Semester? {
        semesters.first { $0.id == id }
    }

    func updateSemester(_ semester: Semester) {
        guard let index = semesters.firstIndex(where: { $0.id == semester.id }) else { return }
        semesters[index] = semester
    }

    func addCourse(_ course: Course, to semesterId: UUID) {
        guard var semester = semester(for: semesterId) else { return }
        semester.courses.append(course)
        updateSemester(semester)
    }

    func updateCourse(_ course: Course, in semesterId: UUID) {
        guard var semester = semester(for: semesterId) else { return }
        guard let index = semester.courses.firstIndex(where: { $0.id == course.id }) else { return }
        semester.courses[index] = course
        updateSemester(semester)
    }

    func deleteCourse(at offsets: IndexSet, semesterId: UUID) {
        guard var semester = semester(for: semesterId) else { return }
        semester.courses.remove(atOffsets: offsets)
        updateSemester(semester)
    }

    func semesterGPA(semesterId: UUID) -> Double {
        guard let semester = semester(for: semesterId) else { return 0 }
        return gpaService.calculateSemesterGPA(courses: semester.courses)
    }

    var overallGPA: Double {
        gpaService.calculateOverallGPA(semesters: semesters)
    }
}
