
import SwiftUI
import Firebase

struct LogInView: View {
    @Binding var signedIn: Bool
    var auth = Auth.auth()
    @State private var showSignUpView = false
    
    var body: some View {
            VStack {
                Button("Logga in") {
                    auth.signInAnonymously { result, error in
                        if error != nil {
                            print("error signing in")
                        } else {
                            signedIn = true
                        }
                    }
                }
                .padding()
                .background(Color("primary"))
                .foregroundColor(Color("text"))
                .cornerRadius(8)
                
                Button(action: {
                    self.showSignUpView = true
                }) {
                    Text("Registrera")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $showSignUpView) {
                    SignUpView()
            }
            
        }
    }
}


#Preview {
    LogInView(signedIn: .constant(false))
}
