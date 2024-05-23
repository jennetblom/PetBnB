import Firebase
import SwiftUI
import Foundation

struct SignUpView: View {
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    
    @State private var showLogInView = false
    @State private var registrationSuccess = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image("catimage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text("Ny användare")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                TextField("Namn:", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                
                TextField("Mejladress:", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .keyboardType(.emailAddress)
                
                SecureField("Lösenord:", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .textContentType(.newPassword)
                
                SecureField("Bekräfta lösenord:", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .textContentType(.newPassword)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                HStack(spacing: 10) {
                    Button(action: {
                        self.showLogInView = true
                    }){
                        Text("Tillbaka")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primary"))
                            .foregroundColor(Color("text"))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        self.register()
                    }) {
                        Text("Registrera")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primary"))
                            .foregroundColor(Color("text"))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 20)
                
                NavigationLink(destination: ExploreView().navigationBarHidden(true), isActive: $registrationSuccess) {
                    EmptyView()
                }
            }
            .sheet(isPresented: $showLogInView) {
                LogInView(signedIn: .constant(false))
            }
            .padding()
        }
        .navigationDestination(isPresented: $registrationSuccess) {
            ExploreView().navigationBarHidden(true)
        }
    }
    
    func register() {
        if password != confirmPassword {
            errorMessage = "Lösenorden matchar inte"
        } else if name.isEmpty || email.isEmpty || password.isEmpty {
            errorMessage = "Alla fält måste vara ifyllda."
        } else {
            errorMessage = ""
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }
                
                guard let user = authResult?.user else { return }
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                        return
                    }
                    let db = Firestore.firestore()
                    db.collection("users").document(user.uid).setData([
                        "name": name,
                        "email": email, // Corrected spelling
                        "password": password,
                        "uid": user.uid
                    ]) { error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                            return
                        }
                        DispatchQueue.main.async {
                            registrationSuccess = true
                        }
                        print("Användare \(user.uid) registrerad med namn \(name) och mejl \(email)")
                        print("registrering bekräftad: \(registrationSuccess)")
                    }
                }
            }
        }
    }
}



