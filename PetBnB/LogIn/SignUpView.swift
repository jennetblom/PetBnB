import Firebase
import SwiftUI
import Foundation

struct SignUpView: View {
    @ObservedObject var viewModel = SignUpViewModel()
    
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
                
                TextField("Namn:", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                
                TextField("Mejladress:", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .keyboardType(.emailAddress)
                
                SecureField("Lösenord:", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .textContentType(.newPassword)
                
                SecureField("Bekräfta lösenord:", text: $viewModel.confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .textContentType(.newPassword)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                HStack(spacing: 10) {
                    Button(action: {
                        self.viewModel.showLogInView = true
                    }){
                        Text("Tillbaka")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primary"))
                            .foregroundColor(Color("text"))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        self.viewModel.register()
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
                
                NavigationLink(destination: ExploreView().navigationBarHidden(true), isActive: $viewModel.registrationSuccess) {
                    EmptyView()
                }
            }
            .sheet(isPresented: $viewModel.showLogInView) {
                LogInView(signedIn: .constant(false))
            }
            .padding()
        }
        .navigationDestination(isPresented: $viewModel.registrationSuccess) {
            ExploreView().navigationBarHidden(true)
        }
    }
    
    
}



