import SwiftUI
import Firebase

struct SignUpView: View {
    @ObservedObject var viewModel = SignUpViewModel()
    @Binding var signedIn: Bool

    var body: some View {
        VStack(spacing: 20) {
            Image("PetHouse")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)

            Text("Ny användare")
                .font(.largeTitle)
                .padding(.bottom, 20)

            VStack(alignment: .leading) {
                Text("Namn:")
                    .padding(.horizontal, 20)

                TextField("Namn:", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
            }

            VStack(alignment: .leading) {
                Text("Mejladress: ")
                    .padding(.horizontal, 20)

                TextField("Mejladress:", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .keyboardType(.emailAddress)
            }

            VStack(alignment: .leading) {
                Text("Lösenord: ")
                    .padding(.horizontal, 20)

                SecureField("Lösenord:", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .textContentType(.newPassword)
            }

            VStack(alignment: .leading) {
                Text("Bekräfta lösenord: ")
                    .padding(.horizontal, 20)

                SecureField("Bekräfta lösenord:", text: $viewModel.confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .textContentType(.newPassword)
            }

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            HStack(spacing: 10) {
                NavigationLink(destination: LogInView(signedIn: $signedIn).navigationBarBackButtonHidden(true)) {
                    Text("Tillbaka")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("primary"))
                        .foregroundColor(Color("text"))
                        .cornerRadius(8)
                }

                Button(action: {
                    self.viewModel.register(signedIn: $signedIn)
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

            NavigationLink(destination: MainTabView(userID: viewModel.userID ?? "").navigationBarBackButtonHidden(true), isActive: $viewModel.registrationSuccess) {
                EmptyView()
            }
        }
        .padding()
    }
}
