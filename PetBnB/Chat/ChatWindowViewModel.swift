

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ChatWindowViewModel : ObservableObject {
    @Published var messages : [Message] = []
    @Published var conversationId: String
    var db  = Firestore.firestore()
    @Published var otherUser : User?
    
    
    init(conversationId : String ){
        self.conversationId = conversationId
        fetchMessages()
        fetchOtherUser()
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
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        let newMessage = Message(senderID: currentUserID, receiverID: otherUser?.id ?? "", content: content, timestamp: Timestamp(date: Date()))
        
        do {
            // Add the new message to the messages collection
            _ = try db.collection("conversations").document(conversationId).collection("messages").addDocument(from: newMessage) { error in
                if let error = error {
                    print("Error sending message: \(error)")
                    return
                }
                
                // Update the lastMessage and timestamp in the conversation document
                self.db.collection("conversations").document(self.conversationId).updateData([
                    "lastMessage": content,
                    "timestamp": Timestamp(date: Date())
                ]) { error in
                    if let error = error {
                        print("Error updating conversation: \(error)")
                    }
                }
            }
        } catch {
            print("Error sending message: \(error)")
        }
    }
    func fetchOtherUser() {
        db.collection("conversations").document(conversationId).getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching conversation document: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot, document.exists,
                  let conversation = try? document.data(as: Conversation.self),
                  let currentUserId = Auth.auth().currentUser?.uid,
                  let otherUserId = conversation.participants.first(where: { $0 != currentUserId }) else {
                print("Failed to decode conversation or find other user")
                return
            }
            
            self.db.collection("users").document(otherUserId).getDocument { userDocumentSnapshot, error in
                if let error = error {
                    print("Error fetching other user document: \(error.localizedDescription)")
                    return
                }
                
                guard let userDocument = userDocumentSnapshot, userDocument.exists,
                      let otherUser = try? userDocument.data(as: User.self) else {
                    print("Failed to decode other user")
                    return
                }
                
                self.otherUser = otherUser
            }
        }
    }
    
}
