import Foundation
import SwiftUI
import Firebase

class SignUpViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = "" {
        didSet {
            checkPasswordLength()
        }
    }
    @Published var confirmPassword = ""
    @Published var errorMessage = ""
    @Published var userID: String? 
    @Published var showLogInView = false
    @Published var registrationSuccess = false {
        didSet{
            if registrationSuccess {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .userDidSignIn, object: nil)
                }
            }
        }
        
    }
    @Published var isPasswordLengthValid = false
    
    func register(signedIn: Binding<Bool>) {

        if password != confirmPassword {
            errorMessage = "Lösenorden matchar inte"
        } else if name.isEmpty || email.isEmpty || password.isEmpty {
            errorMessage = "Alla fält måste vara ifyllda."
        } else if !isPasswordLengthValid {
            errorMessage = "Lösenordet måste vara minst 6 tecken."
        } else {
            errorMessage = ""
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let user = authResult?.user else { return }
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = self.name
                changeRequest.commitChanges { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    let db = Firestore.firestore()
                    db.collection("users").document(user.uid).setData([
                        "name": self.name,
                        "email": self.email,
                        "password": self.password,
                        "uid": user.uid
                    ]) { error in
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                            return
                        }
                        DispatchQueue.main.async {
                            self.registrationSuccess = true
                            signedIn.wrappedValue = true
                        }
                        print("Användare \(user.uid) registrerad med namn \(self.name) och mejl \(self.email)")
                        print("registrering bekräftad: \(self.registrationSuccess)")
                    }
                }
            }
        }
    }
    
    private func checkPasswordLength() {
        isPasswordLengthValid = password.count >= 6
    }
}
extension Notification.Name {
    static let userDidSignIn = Notification.Name("userDidSignIn")
}
