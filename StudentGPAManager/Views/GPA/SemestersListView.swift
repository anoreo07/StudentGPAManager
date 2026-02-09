import SwiftUI

struct SemestersListView: View {
    @EnvironmentObject private var semestersViewModel: SemestersViewModel

    @State private var showAddSheet = false
    @State private var newSemesterName = ""

    var body: some View {
        NavigationStack {
            VStack {
                if semestersViewModel.semesters.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No Semesters")
                            .font(.headline)
                        Text("Create your first semester to manage GPA")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(semestersViewModel.semesters) { semester in
                            NavigationLink {
                                SemesterDetailView(semesterId: semester.id)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(semester.name)
                                        .font(.headline)
                                    Text("\(semester.courses.count) courses • GPA: \(String(format: "%.2f", semestersViewModel.semesterGPA(semesterId: semester.id)))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete(perform: semestersViewModel.deleteSemester)
                    }
                }
            }
            .navigationTitle("GPA Management")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add") {
                        showAddSheet = true
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                NavigationStack {
                    Form {
                        TextField("Semester Name", text: $newSemesterName)
                            .placeholder(when: newSemesterName.isEmpty) {
                                Text("e.g., Fall 2024").foregroundColor(.gray)
                            }
                    }
                    .navigationTitle("New Semester")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showAddSheet = false
                                newSemesterName = ""
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Create") {
                                if !newSemesterName.isEmpty {
                                    semestersViewModel.addSemester(name: newSemesterName)
                                    showAddSheet = false
                                    newSemesterName = ""
                                }
                            }
                            .disabled(newSemesterName.isEmpty)
                        }
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }
}

extension View {
    func placeholder<Content: View>(when shouldShow: Bool, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: .leading) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
