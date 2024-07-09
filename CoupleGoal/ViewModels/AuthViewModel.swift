import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var displayName: String = ""
    @Published var photoURL: URL?
    @Published var errorMessage: String?
    @Published var userId: String? = nil // Ajout de userId

    init() {
        // Écouteur pour les changements d'état d'authentification
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.isAuthenticated = true
                self.email = user.email ?? ""
                self.displayName = user.displayName ?? ""
                self.photoURL = user.photoURL
                self.userId = user.uid // Stocker l'identifiant de l'utilisateur
            } else {
                self.isAuthenticated = false
                self.userId = nil // Réinitialiser l'identifiant de l'utilisateur
            }
        }
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.isAuthenticated = true
                self.email = self.email
                self.userId = result?.user.uid // Store the userId
            }
        }
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.isAuthenticated = true
                self.email = self.email
                self.userId = result?.user.uid // Store the userId
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
            self.userId = nil // Reset the userId
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func updateDisplayName(_ displayName: String, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        changeRequest.commitChanges { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(error)
            } else {
                self.displayName = displayName
                completion(nil)
            }
        }
    }

    func updatePhotoURL(_ photoURL: URL, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.photoURL = photoURL
        changeRequest.commitChanges { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(error)
            } else {
                self.photoURL = photoURL
                completion(nil)
            }
        }
    }
}
