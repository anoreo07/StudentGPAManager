import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var profileViewModel: ProfileViewModel

    @State private var selectedCountry: Country?
    @StateObject private var nationalityViewModel = NationalityViewModel(service: NationalityService())
    @StateObject private var universityViewModel = UniversityViewModel(service: UniversityService())

    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Information") {
                    TextField("Name", text: $profileViewModel.profile.name)
                    TextField("Age", value: $profileViewModel.profile.age, format: .number)
                        .keyboardType(.numberPad)
                    Picker("Gender", selection: $profileViewModel.profile.gender) {
                        Text("").tag("")
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Other").tag("Other")
                    }
                }

                Section("Nationality") {
                    Picker("Nationality", selection: $profileViewModel.profile.nationality) {
                        Text("Select...").tag("")
                        ForEach(nationalityViewModel.countries) { country in
                            Text(country.name.common).tag(country.name.common)
                        }
                    }
                }

                Section("University") {
                    if profileViewModel.profile.nationality.isEmpty {
                        Text("Select nationality first")
                            .foregroundColor(.gray)
                    } else {
                        Picker("University", selection: $profileViewModel.profile.university) {
                            Text("Select...").tag("")
                            ForEach(universityViewModel.universities) { uni in
                                Text(uni.name).tag(uni.name)
                            }
                        }
                        .onChange(of: profileViewModel.profile.nationality) { _, newCountry in
                            Task {
                                await universityViewModel.load(country: newCountry)
                            }
                        }
                    }
                }

                Section {
                    Button {
                        Task {
                            await profileViewModel.saveProfile()
                        }
                    } label: {
                        HStack {
                            Spacer()
                            if profileViewModel.isLoading {
                                ProgressView()
                            } else {
                                Text("Save Profile")
                            }
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                Task {
                    await profileViewModel.loadProfile()
                    await nationalityViewModel.load()
                }
            }
            .alert(item: $profileViewModel.errorAlert) { alert in
                Alert(title: Text("Error"), message: Text(alert.message))
            }
        }
    }
}
