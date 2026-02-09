import SwiftUI

struct TranscriptView: View {
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var semestersViewModel: SemestersViewModel

    @State private var exportResult: URL?
    @State private var showShareSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Student Information")
                            .font(.headline)
                        HStack {
                            Text("Name:").fontWeight(.semibold)
                            Text(profileViewModel.profile.name.isEmpty ? "N/A" : profileViewModel.profile.name)
                            Spacer()
                        }
                        HStack {
                            Text("University:").fontWeight(.semibold)
                            Text(profileViewModel.profile.university.isEmpty ? "N/A" : profileViewModel.profile.university)
                            Spacer()
                        }
                        HStack {
                            Text("Overall GPA:").fontWeight(.semibold)
                            Text(String(format: "%.2f", semestersViewModel.overallGPA))
                                .foregroundColor(.blue)
                            Spacer()
                        }
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                    if semestersViewModel.semesters.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 36))
                                .foregroundColor(.gray)
                            Text("No Semesters")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(40)
                    } else {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Semesterwise Breakdown")
                                .font(.headline)

                            ForEach(semestersViewModel.semesters) { semester in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(semester.name)
                                        .font(.headline)
                                    ForEach(semester.courses) { course in
                                        HStack {
                                            Text(course.name)
                                                .font(.subheadline)
                                            Spacer()
                                            Text("\(course.credits) cr • \(String(format: "%.2f", course.grade))")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Text("GPA: \(String(format: "%.2f", semestersViewModel.semesterGPA(semesterId: semester.id)))")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.blue)
                                }
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                    }

                    Button {
                        exportTranscript()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Export as PDF")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding(16)
            }
            .navigationTitle("Transcript")
            .sheet(isPresented: $showShareSheet) {
                if let url = exportResult {
                    ShareSheet(items: [url])
                }
            }
        }
    }

    private func exportTranscript() {
        let service = TranscriptExportService()
        do {
            let result = try service.exportTranscript(
                profile: profileViewModel.profile,
                semesters: semestersViewModel.semesters
            )
            exportResult = result.url
            showShareSheet = true
        } catch {
            print("Export failed: \(error)")
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
