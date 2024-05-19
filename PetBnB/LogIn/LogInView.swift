
import SwiftUI
import Firebase

struct LogInView: View {
    @Binding var signedIn: Bool
    var auth = Auth.auth()
    
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
        }
    }
}

#Preview {
    LogInView(signedIn: .constant(false))
}
