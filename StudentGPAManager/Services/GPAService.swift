import Foundation

final class GPAService {
    func calculateSemesterGPA(courses: [Course]) -> Double {
        let totalCredits = courses.reduce(0) { $0 + $1.credits }
        guard totalCredits > 0 else { return 0 }
        let totalPoints = courses.reduce(0.0) { $0 + (Double($1.credits) * $1.grade) }
        return totalPoints / Double(totalCredits)
    }

    func calculateOverallGPA(semesters: [Semester]) -> Double {
        let allCourses = semesters.flatMap { $0.courses }
        return calculateSemesterGPA(courses: allCourses)
    }
}
