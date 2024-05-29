import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var senderID: String
    var receiverID: String
    var content: String
    var timestamp: Timestamp
}
