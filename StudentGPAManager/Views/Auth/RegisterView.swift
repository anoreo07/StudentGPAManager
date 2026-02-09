import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var localError: ErrorAlert?

    var passwordsMatch: Bool {
        password == confirmPassword && !password.isEmpty
    }

    var body: some View {
        Form {
            Section("Create Account") {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                SecureField("Password", text: $password)
                SecureField("Confirm Password", text: $confirmPassword)
            }

            if !password.isEmpty && !passwordsMatch {
                Section {
                    Text("Passwords do not match")
                        .foregroundColor(.red)
                }
            }

            Section {
                Button {
                    Task {
                        await authViewModel.register(email: email, password: password)
                    }
                } label: {
                    HStack {
                        Spacer()
                        if authViewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Create Account")
                        }
                        Spacer()
                    }
                }
                .disabled(!passwordsMatch || email.isEmpty)
            }
        }
        .navigationTitle("Create Account")
        .alert(item: $authViewModel.errorAlert) { alert in
            Alert(title: Text("Registration Failed"), message: Text(alert.message))
        }
    }
}
