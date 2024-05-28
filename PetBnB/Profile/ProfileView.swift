import SwiftUI

struct ProfileView: View {
    @State private var selectedSegment = 0
    @StateObject var viewModel = ProfileViewModel()
    @State var hasChanges: Bool = false
    @State var isLoading: Bool = true 
    @State var ignoreChanges: Bool = true

    let segments = ["Uthyrare", "Hyresgäst"]

    var body: some View {
        VStack {
            Picker("Select View", selection: $selectedSegment) {
                ForEach(0..<segments.count) { index in
                    Text(segments[index])
                        .tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            profileHeaderWithImageAndStars(rating: $viewModel.rating)

            if selectedSegment == 0 {
                HomeOwnerView(hasChanges: $hasChanges, isLoading: $isLoading, ignoreChanges: $ignoreChanges)
            } else {
                HomeGuestView()
            }
            Spacer()

            if hasChanges {
                Button("Spara") {
                    hasChanges = false
                    viewModel.saveUserProfileToFirebase()
                }
                .frame(width: 220, height: 40)
                .background(Color("primary"))
                .foregroundColor(.black)
                .cornerRadius(10.0)
                .padding()
            }

        }
        .onAppear {
            viewModel.fetchUserProfileFromFirebase {
                isLoading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    ignoreChanges = false
                }
            }
        }
        .environmentObject(viewModel)
    }
}

struct profileHeaderWithImageAndStars: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Binding var rating: Int

    var body: some View {
        HStack {
            Image("catimage")
                .resizable()
                .frame(width: 100, height: 100)
                .offset(x: 50)

            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.name)
                        .font(.title2)
                        .offset(x: 55)
                    Spacer()
                }

                RatingBar(rating: $rating)
                    .offset(x: 55, y: -10)
            }
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}
