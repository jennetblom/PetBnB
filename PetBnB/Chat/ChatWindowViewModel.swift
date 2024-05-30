

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ChatWindowViewModel : ObservableObject {
    @Published var messages : [Message] = []
    @Published var conversationId: String
    var db  = Firestore.firestore()

    
    
    init(conversationId : String){
        self.conversationId = conversationId
        fetchMessages()
    }
    
    func fetchMessages() {
       
        
        db.collection("conversations").document(conversationId).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No messages found")
                    return
                }
                self.messages = documents.compactMap { doc -> Message? in
                    try? doc.data(as: Message.self)
                }
            }
    }
    func sendMessage(_ content: String) {
           let currentUserID = Auth.auth().currentUser?.uid ?? ""
           let newMessage = Message(senderID: currentUserID, receiverID: "", content: content, timestamp: Timestamp(date: Date()))

           do {
               _ = try db.collection("conversations").document(conversationId).collection("messages").addDocument(from: newMessage)
           } catch {
               print("Error sending message: \(error)")
           }
       }

    
}
