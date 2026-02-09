//
//  StudentGPAManagerApp.swift
//  StudentGPAManager
//
//  Created by Nguyễn Hải An on 7/2/26.
//

import FirebaseCore
import SwiftUI

@main
struct StudentGPAManagerApp: App {
    @StateObject private var authViewModel: AuthViewModel
    @StateObject private var profileViewModel: ProfileViewModel
    @StateObject private var semestersViewModel: SemestersViewModel

    init() {
        FirebaseApp.configure()

        let authService = AuthService()
        let userService = UserService()
        let gpaService = GPAService()
        let semesterStore = SemesterStore()

        let authVM = AuthViewModel(authService: authService)
        _authViewModel = StateObject(wrappedValue: authVM)
        _profileViewModel = StateObject(
            wrappedValue: ProfileViewModel(
                userService: userService,
                userIdProvider: { authVM.user?.uid }
            )
        )
        _semestersViewModel = StateObject(
            wrappedValue: SemestersViewModel(gpaService: gpaService, store: semesterStore)
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(profileViewModel)
                .environmentObject(semestersViewModel)
        }
    }
}
