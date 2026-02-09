import FirebaseAuth
import Foundation

final class UserService {

    func fetchProfile(userId: String) async throws -> UserProfile? {
        // Mock implementation - returns nil
        // TODO: Implement proper data persistence with UserDefaults or Core Data
        return nil
    }

    func saveProfile(_ profile: UserProfile) async throws {
        // Mock implementation
        // TODO: Implement proper data persistence with UserDefaults or Core Data
    }
}

