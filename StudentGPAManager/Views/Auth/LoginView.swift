import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        Form {
            Section("Welcome") {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                SecureField("Password", text: $password)
            }

            Section {
                Button {
                    Task {
                        await authViewModel.login(email: email, password: password)
                    }
                } label: {
                    HStack {
                        Spacer()
                        if authViewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Login")
                        }
                        Spacer()
                    }
                }
                .disabled(email.isEmpty || password.isEmpty)
            }

            Section {
                NavigationLink("Create an account") {
                    RegisterView()
                }
            }
        }
        .navigationTitle("Login")
        .alert(item: $authViewModel.errorAlert) { alert in
            Alert(title: Text("Login Failed"), message: Text(alert.message))
        }
    }
}
