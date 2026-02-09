import SwiftUI

struct AddCourseSheet: View {
    @EnvironmentObject private var semestersViewModel: SemestersViewModel

    @Binding var courseForm: CourseFormState
    let semesterId: UUID
    @Binding var isPresented: Bool

    var isEditingExisting: Bool {
        if let semester = semestersViewModel.semester(for: semesterId) {
            return semester.courses.contains { $0.id == courseForm.id }
        }
        return false
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Course Name", text: $courseForm.name)
                    .placeholder(when: courseForm.name.isEmpty) {
                        Text("e.g., Calculus I").foregroundColor(.gray)
                    }

                Picker("Credits", selection: $courseForm.credits) {
                    ForEach(1...12, id: \.self) { credit in
                        Text("\(credit)").tag(String(credit))
                    }
                }
                if courseForm.credits.isEmpty {
                    Text("Select credits")
                        .onAppear { courseForm.credits = "3" }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Grade (0.0 - 4.0)")
                        .font(.headline)
                    TextField("e.g., 3.8", text: $courseForm.grade)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle(isEditingExisting ? "Edit Course" : "Add Course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditingExisting ? "Update" : "Add") {
                        saveCourse()
                        isPresented = false
                    }
                    .disabled(!isFormValid)
                }
            }
        }
        .presentationDetents([.medium])
    }

    private var isFormValid: Bool {
        !courseForm.name.isEmpty &&
            !courseForm.credits.isEmpty &&
            !courseForm.grade.isEmpty &&
            Double(courseForm.grade) ?? -1 >= 0 &&
            Double(courseForm.grade) ?? -1 <= 4.0
    }

    private func saveCourse() {
        guard isFormValid else { return }
        guard let credits = Int(courseForm.credits),
              let grade = Double(courseForm.grade) else { return }

        let course = Course(id: courseForm.id, name: courseForm.name, credits: credits, grade: grade)

        if isEditingExisting {
            semestersViewModel.updateCourse(course, in: semesterId)
        } else {
            semestersViewModel.addCourse(course, to: semesterId)
        }
    }
}
