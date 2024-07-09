import SwiftUI
import Firebase
import FirebaseStorage

struct AccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var newEmail = ""
    @State private var newPassword = ""
    @State private var newDisplayName = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            if let photoURL = authViewModel.photoURL {
                AsyncImage(url: photoURL) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            }
            
            Text("Welcome, \(authViewModel.displayName)")
                .padding()

            TextField("New Email", text: $newEmail)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)

            Button(action: {
                updateEmail()
            }) {
                Text("Update Email")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            SecureField("New Password", text: $newPassword)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)

            Button(action: {
                updatePassword()
            }) {
                Text("Change Password")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            TextField("New Display Name", text: $newDisplayName)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)

            Button(action: {
                updateDisplayName()
            }) {
                Text("Update Display Name")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            Button(action: {
                showImagePicker = true
            }) {
                Text("Change Profile Picture")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .onChange(of: selectedImage) { newImage in
                if let newImage = newImage {
                    uploadProfileImage(newImage)
                }
            }

            Button(action: {
                signOut()
            }) {
                Text("Sign Out")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            Spacer()
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Info"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func updateEmail() {
        guard !newEmail.isEmpty else { return }
        Auth.auth().currentUser?.updateEmail(to: newEmail) { error in
            if let error = error {
                alertMessage = error.localizedDescription
            } else {
                alertMessage = "Email updated successfully."
                authViewModel.email = newEmail
            }
            showingAlert = true
        }
    }

    private func updatePassword() {
        guard !newPassword.isEmpty else { return }
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                alertMessage = error.localizedDescription
            } else {
                alertMessage = "Password changed successfully."
            }
            showingAlert = true
        }
    }

    private func updateDisplayName() {
        guard !newDisplayName.isEmpty else { return }
        authViewModel.updateDisplayName(newDisplayName) { error in
            if let error = error {
                alertMessage = error.localizedDescription
            } else {
                alertMessage = "Display name updated successfully."
                authViewModel.displayName = newDisplayName
            }
            showingAlert = true
        }
    }

    private func uploadProfileImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        let storageRef = Storage.storage().reference().child("profile_images").child(UUID().uuidString)
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.showingAlert = true
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    self.alertMessage = error.localizedDescription
                    self.showingAlert = true
                    return
                }

                if let url = url {
                    authViewModel.updatePhotoURL(url) { error in
                        if let error = error {
                            self.alertMessage = error.localizedDescription
                        } else {
                            self.alertMessage = "Profile picture updated successfully."
                        }
                        self.showingAlert = true
                    }
                }
            }
        }
    }

    private func signOut() {
        authViewModel.signOut()
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView().environmentObject(AuthViewModel())
    }
}
