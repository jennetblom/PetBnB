
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ChatViewModel : ObservableObject {
    @Published var conversations : [Conversation] = []
    var db = Firestore.firestore()
    var auth = Auth.auth()
    @Published var currentUser : User?
    @Published var otherUsers: [String: User] = [:]
    var firestoreUtils = FirestoreUtils()
    
    
    func fetchConversations(completion: @escaping () -> Void) {
        guard let userId = auth.currentUser?.uid else { return }
        
        fetchUser(withID: userId)
        
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
                
                self.fetchOtherUsers()
                
                // Calculate unread messages count for each conversation
                self.calculateUnreadMessagesCount {
                    completion()
                }
            }
    }
    
    func calculateUnreadMessagesCount(completion: @escaping () -> Void) {
        for conversation in conversations {
            guard let userId = auth.currentUser?.uid else { return }
            
            // Get unread msg for current user
            let unreadCount = conversation.unreadMessagesCount?[userId] ?? 0
            
            // Maybe some code to use the count
            
            print("Unread messages for conversation \(conversation.id ?? ""): \(unreadCount)")
        }
        
        completion()
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
                let newConversation = Conversation(participants: [currentUserID, userID], lastMessage: "", lastMessageSenderId: "", timestamp: Timestamp(date: Date()))
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
    private func fetchOtherUsers() {
          for conversation in conversations {
              for participant in conversation.participants {
                  if participant != auth.currentUser?.uid {
                      fetchUser(withID: participant)
                  }
              }
          }
      }
       
    func fetchUser(withID id: String, completion: (() -> Void)? = nil) {
        firestoreUtils.fetchUser(withID: id) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    if id == self?.auth.currentUser?.uid {
                        self?.currentUser = user // Store current user
                        self?.currentUser?.profilePictureUrl  = user.profilePictureUrl // Set profile picture
                    } else {
                        self?.otherUsers[id] = user // Store other user in dictionary
                    }
                    completion?()
                }
            case .failure(let error):
                print("Error fetching user: \(error)")
                // Handle the decoding error
                // For example, provide a default URL or placeholder image
                // self?.currentUser?.profilePicture = URL(string: "default_profile_picture_url")
                completion?()
            }
        }
    }
       func getUserName(for userId: String) -> String {
           return otherUsers[userId]?.name ?? "Loading..."
       }
       
       func getUserProfilePicture(for userId: String) -> URL? {
           return otherUsers[userId]?.profilePictureUrl
       }
}
