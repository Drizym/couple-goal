import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Message: Codable, Identifiable {
    @DocumentID var id: String?
    var content: String
    var senderID: String
    var timestamp: Timestamp
    
    init(id: String? = nil, content: String, senderID: String, timestamp: Timestamp) {
        self.id = id
        self.content = content
        self.senderID = senderID
        self.timestamp = timestamp
    }
}
