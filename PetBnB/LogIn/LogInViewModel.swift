

import SwiftUI
import Firebase

class LogInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    @Published var signedIn: Bool = false
    
    
    private var auth = Auth.auth()
    
    func signIn() {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error sining in: \(error.localizedDescription)")
                return
            }
            
            self.signedIn = true
        }
    }
    
    
    func signUp() {
        
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
                return
            }
            self.signedIn = true
        }
    }
}
