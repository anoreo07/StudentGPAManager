import SwiftUI

struct SemesterDetailView: View {
    @EnvironmentObject private var semestersViewModel: SemestersViewModel

    let semesterId: UUID

    @State private var showAddCourse = false
    @State private var courseForm = CourseFormState()

    var semester: Semester? {
        semestersViewModel.semester(for: semesterId)
    }

    var body: some View {
        VStack {
            if let semester = semester {
                ScrollView {
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            Text("Semester GPA")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(String(format: "%.2f", semestersViewModel.semesterGPA(semesterId: semesterId)))
                                .font(.system(size: 42, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                        if semester.courses.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "book")
                                    .font(.system(size: 36))
                                    .foregroundColor(.gray)
                                Text("No Courses")
                                    .font(.headline)
                                Text("Add your first course")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(40)
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Courses (\(semester.courses.count))")
                                    .font(.headline)

                                ForEach(semester.courses) { course in
                                    HStack(spacing: 16) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(course.name)
                                                .font(.headline)
                                            Text("\(course.credits) credits")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Text(String(format: "%.2f", course.grade))
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                    }
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .contextMenu {
                                        Button("Edit") {
                                            courseForm = CourseFormState(course: course)
                                            showAddCourse = true
                                        }
                                        Button("Delete", role: .destructive) {
                                            if let index = semester.courses.firstIndex(where: { $0.id == course.id }) {
                                                var updated = semester
                                                updated.courses.remove(at: index)
                                                semestersViewModel.updateSemester(updated)
                                            }
                                        }
                                    }
                                }

                                List {
                                    ForEach(semester.courses) { course in
                                        Text("")
                                    }
                                    .onDelete { offsets in
                                        semestersViewModel.deleteCourse(at: offsets, semesterId: semesterId)
                                    }
                                }
                                .frame(height: 0)
                                .scrollDisabled(true)
                                .listStyle(.plain)
                            }
                        }
                    }
                    .padding(16)
                }

                Spacer()

                Button {
                    courseForm = CourseFormState()
                    showAddCourse = true
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Course")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(16)
            }
        }
        .navigationTitle(semester?.name ?? "Semester")
        .sheet(isPresented: $showAddCourse) {
            AddCourseSheet(
                courseForm: $courseForm,
                semesterId: semesterId,
                isPresented: $showAddCourse
            )
        }
    }
}

struct CourseFormState {
    var id: UUID = UUID()
    var name: String = ""
    var credits: String = ""
    var grade: String = ""

    init() {}

    init(course: Course) {
        id = course.id
        name = course.name
        credits = String(course.credits)
        grade = String(format: "%.2f", course.grade)
    }
}
