

import SwiftUI
import Firebase

class LogInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    @Published var signedIn: Bool = false
    @Published var errorMessage: String? = nil
    
    
    private var auth = Auth.auth()
    
    
    init() {
        if let savedEmail = UserDefaults.standard.string(forKey: "email"),
           let savedPassword = UserDefaults.standard.string(forKey: "password") {
            self.email = savedEmail
            self.password = savedPassword
            self.rememberMe = true
            
        }
    }
    
    func signIn() {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                print("Error code: \(error.code), \(error.localizedDescription)")
                self.errorMessage = "Felaktiga uppgifter. Försök igen! "
                self.signedIn = false
                return
            }
            
            self.signedIn = true
            self.errorMessage = nil
            if self.rememberMe {
                UserDefaults.standard.set(self.email, forKey: "email")
                UserDefaults.standard.set(self.password, forKey: "password")
                
            } else {
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "password")
            }
        }
    }
}
