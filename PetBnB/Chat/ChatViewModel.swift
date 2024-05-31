
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ChatViewModel : ObservableObject {
    @Published var conversations : [Conversation] = []
    var db = Firestore.firestore()
    var auth = Auth.auth()
    @Published var currentUser : User?
    @Published var otherUser: User?
    var firestoreUtils = FirestoreUtils()
    
    func fetchConversations(completion: @escaping () -> Void) {
        guard let userId = auth.currentUser?.uid else { return }
        
        db.collection("conversations")
            .whereField("participants", arrayContains: userId)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching conversations \(error)")
                    return
                }
                self.conversations = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Conversation.self)
                } ?? []
                
                completion() // Call completion handler when conversations are fetched
            }
    }
    func startConversation(with userID: String, completion: @escaping (String?) -> Void) {
        let currentUserID = Auth.auth().currentUser?.uid ?? ""
        
        // Check if a conversation already exists
        db.collection("conversations")
            .whereField("participants", arrayContains: currentUserID)
            .getDocuments { (snapshot, error) in
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        if let participants = data["participants"] as? [String], participants.contains(userID) {
                            completion(document.documentID)
                            return
                        }
                    }
                }
                
                // If no conversation exists, create a new one
                let newConversation = Conversation(participants: [currentUserID, userID], lastMessage: "", timestamp: Timestamp(date: Date()))
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
    func fetchUser(withID id: String, forCurrentUser isCurrentUser: Bool) {
           firestoreUtils.fetchUser(withID: id) { [weak self] result in
               switch result {
               case .success(let user):
                   DispatchQueue.main.async {
                       if isCurrentUser {
                           self?.currentUser = user
                       } else {
                           self?.otherUser = user
                       }
                   }
               case .failure(let error):
                   print("Error fetching user: \(error)")
               }
           }
       }

       func fetchCurrentUser() {
           guard let uid = Auth.auth().currentUser?.uid else {
               print("No authenticated user found.")
               return
           }

           fetchUser(withID: uid, forCurrentUser: true)
       }
}
