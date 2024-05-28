
import SwiftUI
import Firebase

struct LogInView: View {
    @Binding var signedIn: Bool
    @StateObject private var viewModel = LogInViewModel()
    @State private var showSignUpView = false
    var auth = Auth.auth()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image("PetHouse")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 40)
                
                Text("Logga in")
                    .font(.custom("SF Pro Text", size: 34))
                    .fontWeight(.semibold)
                    .padding(.bottom, 40)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Mejladress: ")
                        .font(.custom("SF Pro Text", size: 15))
                        .foregroundColor(.black)
                    
                    TextField("Mejladress", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .font(.custom("SF Pro Text", size: 15))
                    
                    
                    Text("Lösenord: ")
                        .font(.custom("SF Pro Text", size: 15))
                        .foregroundColor(.black)
                    
                    
                    SecureField("Lösenord", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.custom("SF Pro Text", size: 15))
                    
                    
                    Toggle(isOn: $viewModel.rememberMe) {
                        Text("Kom ihåg mig ")
                            .font(.custom("SF Pro Text", size: 15))
                        
                    }
                    
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.custom("SF Pro Text", size: 15))
                            .padding(.horizontal)
                            .padding(.top, 10)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                
                HStack {
                    NavigationLink(destination: SignUpView(signedIn: $signedIn).navigationBarBackButtonHidden(true)) {
                        Text("Registrera")
                            .font(.custom("SF Pro Text", size: 15))
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color("primary"))
                            .foregroundColor(Color("text"))
                            .cornerRadius(10)
                    }
                    
                    /*HStack {
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
                     
                     }*/
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
                .padding(.horizontal, 40)
                
                Spacer()
                
            }
            .onChange(of: viewModel.signedIn) { newValue in
                if newValue {
                    signedIn = true
                }
            }
            .sheet(isPresented: $showSignUpView) {
                SignUpView(signedIn: $signedIn)
            }
        }
    }
}



#Preview {
    LogInView(signedIn: .constant(false))
}

