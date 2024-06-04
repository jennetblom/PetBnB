

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
        markConversationAsRead()
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
        let receiverID = otherUser?.id ?? ""
        
        let newMessage = Message(senderID: currentUserID, receiverID: receiverID, content: content, timestamp: Timestamp(date: Date()))
        
        do {
            // Add the new message to the messages collection
            _ = try db.collection("conversations").document(conversationId).collection("messages").addDocument(from: newMessage) { error in
                if let error = error {
                    print("Error sending message: \(error)")
                    return
                }
                
                // Update unreadMessagesCount for the receiver
                self.updateUnreadMessagesCount(receiverID: receiverID)
                
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
    
    func updateUnreadMessagesCount(receiverID: String) {
        // Increment unreadMessagesCount for the receiver
        let conversationRef = db.collection("conversations").document(conversationId)
        conversationRef.getDocument { documentSnapshot, error in
            if let document = documentSnapshot, document.exists {
                var data = document.data() ?? [:]
                var unreadMessagesCount = data["unreadMessagesCount"] as? [String: Int] ?? [:]
                
                // Increment unread count for the receiver
                unreadMessagesCount[receiverID] = (unreadMessagesCount[receiverID] ?? 0) + 1
                
                // Update the document with the new unreadMessagesCount
                conversationRef.updateData(["unreadMessagesCount": unreadMessagesCount]) { error in
                    if let error = error {
                        print("Error updating unreadMessagesCount: \(error)")
                    }
                }
            } else {
                print("Conversation document does not exist")
            }
        }
    }
    
    func markConversationAsRead() {
        // Get conversation from FB
        let conversationRef = db.collection("conversations").document(conversationId)
        conversationRef.getDocument { documentSnapshot, error in
            if let document = documentSnapshot, document.exists {
                var data = document.data() ?? [:]
                var unreadMessagesCount = data["unreadMessagesCount"] as? [String: Int] ?? [:]
                
                // Update unreadMessagesCount to 0 for current user
                if let currentUserID = Auth.auth().currentUser?.uid {
                    unreadMessagesCount[currentUserID] = 0
                }
                
                // Update conversation with new unreadMessagesCount
                conversationRef.updateData(["unreadMessagesCount": unreadMessagesCount]) { error in
                    if let error = error {
                        print("Error updating unreadMessagesCount: \(error)")
                    }
                }
            } else {
                print("Conversation document does not exist")
            }
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
