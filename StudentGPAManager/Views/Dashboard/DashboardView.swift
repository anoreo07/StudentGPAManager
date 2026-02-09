import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var semestersViewModel: SemestersViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        Text("Overall GPA")
                            .font(.headline)
                            .foregroundColor(.gray)

                        Text(String(format: "%.2f", semestersViewModel.overallGPA))
                            .font(.system(size: 56, weight: .bold))
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                    if semestersViewModel.semesters.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text("No Semesters")
                                .font(.headline)
                            Text("Add a semester to get started")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(40)
                    } else {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Semesters")
                                .font(.headline)

                            ForEach(semestersViewModel.semesters) { semester in
                                NavigationLink {
                                    SemesterDetailView(semesterId: semester.id)
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(semester.name)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            Text("\(semester.courses.count) courses")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Text(String(format: "%.2f", semestersViewModel.semesterGPA(semesterId: semester.id)))
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                    }
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Dashboard")
        }
    }
}
