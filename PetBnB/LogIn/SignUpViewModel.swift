
import Foundation
import Firebase

class SignUpViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage = ""
    
    @Published var showLogInView = false
    @Published var registrationSuccess = false
    
    func register() {
        if password != confirmPassword {
            errorMessage = "Lösenorden matchar inte"
        } else if name.isEmpty || email.isEmpty || password.isEmpty {
            errorMessage = "Alla fält måste vara ifyllda."
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
                        "email": self.email, // Corrected spelling
                        "password": self.password,
                        "uid": user.uid
                    ]) { error in
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                            return
                        }
                        DispatchQueue.main.async {
                            self.registrationSuccess = true
                        }
                        print("Användare \(user.uid) registrerad med namn \(self.name) och mejl \(self.email)")
                        print("registrering bekräftad: \(self.registrationSuccess)")
                    }
                }
            }
        }
    }
}
