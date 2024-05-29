
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ChatViewModel : ObservableObject {
    @Published var conversations : [Conversation] = []
    var db = Firestore.firestore()
    var auth = Auth.auth()
    @Published var isChatActive: Bool = false
    
    init() {
        fetchConversations()
    }
    func fetchConversations() {
        guard let userId = auth.currentUser?.uid else { return }
        
        db.collection("conversations")
            .whereField("userId", arrayContains: userId)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching conversations \(error)")
                    return
                }
                self.conversations = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Conversation.self)
                } ?? []
            }
    }
    func startConversation(with user: User, completion: @escaping (String?) -> Void) {
        let currentUserID = Auth.auth().currentUser?.uid ?? ""
        
        // Check if a conversation already exists
        db.collection("conversations")
            .whereField("participants", arrayContains: currentUserID)
            .getDocuments { (snapshot, error) in
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        if let participants = data["participants"] as? [String], participants.contains(user.id ?? "") {
                            completion(document.documentID)
                            return
                        }
                    }
                }
                
                // If no conversation exists, create a new one
                let newConversation = Conversation(participants: [currentUserID, user.id ?? ""], lastMessage: "", timestamp: Timestamp(date: Date()))
                let conversationRef = self.db.collection("conversations").document()
                do {
                    try conversationRef.setData(from: newConversation) { error in
                        if let error = error {
                            print("Error creating conversation: \(error)")
                            completion(nil)
                        } else {
                            completion(conversationRef.documentID)
                        }
                    }
                } catch {
                    print("Error creating conversation: \(error)")
                    completion(nil)
                }
            }
    }
}
