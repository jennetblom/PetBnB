
import Foundation
import Firebase

class ProfileViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    @Published var users = [User]()
}
