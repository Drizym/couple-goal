import Foundation
import Firebase
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private var db = Firestore.firestore()

    init() {
        fetchMessages()
    }

    func sendMessage(content: String, senderID: String) {
        let message = Message(content: content, senderID: senderID, timestamp: Timestamp(date: Date()))
        do {
            _ = try db.collection("messages").addDocument(from: message)
        } catch let error {
            print("Error writing message to Firestore: \(error)")
        }
    }

    func fetchMessages() {
        db.collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error)")
                    return
                }
                self.messages = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Message.self)
                } ?? []
            }
    }
}
