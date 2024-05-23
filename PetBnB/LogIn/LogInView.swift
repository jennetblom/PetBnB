
import SwiftUI
//import Firebase

struct LogInView: View {
    @Binding var signedIn: Bool
    @StateObject private var viewModel = LogInViewModel()
    @State private var showSignUpView = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("PetHouse")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.bottom, 40)
            
            
            HStack {
                
                Text("Inloggning")
                    .font(.custom("SF Pro Text", size: 34))
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding(.bottom, 40)
            .padding(.horizontal)
            
            
            VStack(alignment: .leading) {
                Text("Mejladress: ")
                    .font(.custom("SF Pro Text", size: 15))
                    .foregroundColor(.black)
                
                TextField("Mejladress", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .font(.custom("SF Pro Text", size: 15))
                
            }
            
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            
            VStack(alignment: .leading) {
                Text("Lösenord: ")
                    .font(.custom("SF Pro Text", size: 15))
                    .foregroundColor(.black)
                
                
                SecureField("Lösenord", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.custom("SF Pro Text", size: 15))
            }
            
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            Toggle(isOn: $viewModel.rememberMe) {
                Text("Kom ihåg mig ")
                    .font(.custom("SF Pro Text", size: 15))
                
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            HStack {
                Button(action: {
                    showSignUpView = true
                }) {
                    Text("Registrera")
                        .font(.custom("SF Pro Text", size: 15))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color("primary"))
                        .foregroundColor(Color("text"))
                        .cornerRadius(10)
                    
                }
                .padding(.horizontal)
                
                Button(action: {
                    viewModel.signIn()
                }) {
                    Text("Logga in")
                        .font(.custom("SF Pro Text", size: 15))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color("primary"))
                        .foregroundColor(Color("text"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
            
            Spacer()
                .onChange(of: viewModel.signedIn) { newValue in
                    if newValue {
                        signedIn = true
                    }
                }
                .sheet(isPresented: $showSignUpView) {
                    SignUpView()
                }
        }
    }
}


#Preview {
    LogInView(signedIn: .constant(false))
}
