import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager: ObservableObject {
    private var db = Firestore.firestore()

    func addMessage(_ message: Message) {
        do {
            let _ = try db.collection("messages").addDocument(from: message)
        } catch {
            print("Error adding message: \(error.localizedDescription)")
        }
    }
}

