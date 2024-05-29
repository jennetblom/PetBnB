import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    var userID: String
    var isEditable: Bool = true
    @State private var selectedSegment: Int
    @State var hasChanges: Bool = false
    @State var isLoading: Bool = true
    @State var ignoreChanges: Bool = true
    @State private var showImagePicker = false
    @State private var selectedProfileImage: UIImage?
    @State private var selectedImages = [UIImage]()

    let segments = ["Uthyrare", "Hyresgäst"]

    init(userID: String, isEditable: Bool = true) {
            self.userID = userID
            self.isEditable = isEditable
            _selectedSegment = State(initialValue: isEditable ? 0 : 1)
        }
    
    var body: some View {
        VStack {
            if isEditable {
                Picker("Select View", selection: $selectedSegment) {
                    ForEach(0..<segments.count) { index in
                        Text(segments[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }

            profileHeaderWithImageAndStars(rating: $viewModel.rating, showImagePicker: $showImagePicker, selectedImage: $selectedProfileImage, profileImageUrl: $viewModel.profilePictureUrl)

            if selectedSegment == 0 {
                HomeOwnerView(hasChanges: $hasChanges, isLoading: $isLoading, ignoreChanges: $ignoreChanges, isEditable: isEditable)
            } else {
                HomeGuestView(hasChanges: $hasChanges, isLoading: $isLoading, ignoreChanges: $ignoreChanges, isEditable: isEditable)
            }
            Spacer()

            if hasChanges && isEditable {
                Button("Spara") {
                    hasChanges = false
                    viewModel.saveUserProfileToFirebase()
                    saveProfile()
                }
                .frame(width: 220, height: 40)
                .background(Color("primary"))
                .foregroundColor(.black)
                .cornerRadius(10.0)
                .padding()
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImages: $selectedImages, selectedSingleImage: $selectedProfileImage, isSingleImage: true)
        }
        .onAppear {
            viewModel.fetchUserProfileFromFirebase(for: userID) {
                isLoading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    ignoreChanges = false
                }
            }
        }
        .environmentObject(viewModel)
    }
    
    private func saveProfile() {
        if let selectedImage = selectedProfileImage {
            viewModel.uploadProfileImage(selectedImage) { url in
                if let url = url {
                    viewModel.profilePictureUrl = url
                    viewModel.saveProfileImageUrl(url)
                    viewModel.saveUserProfileToFirebase()
                    hasChanges = false
                }
            }
        } else {
            viewModel.saveUserProfileToFirebase()
            hasChanges = false
        }
    }
}

struct profileHeaderWithImageAndStars: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Binding var rating: Int
    @Binding var showImagePicker: Bool
    @Binding var selectedImage: UIImage?
    @Binding var profileImageUrl: URL?

    var body: some View {
        HStack (alignment: .center) {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)
                    .clipped()
                    .onTapGesture {
                        showImagePicker = true
                    }
            } else if let profileImageUrl = profileImageUrl {
                AsyncImage(url: profileImageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    case .success(let image):
                        image.resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .clipped()
                            .onTapGesture {
                                showImagePicker = true
                            }
                    case .failure:
                        Image("profileIcon")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                                     )
                            .onTapGesture {
                                showImagePicker = true
                            }
                    @unknown default:
                        Image("profileIcon")
                            .resizable()
                            .frame(width: 100, height: 100)
                            //.cornerRadius(20)
                            .clipped()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                                     )
                            .onTapGesture {
                                showImagePicker = true
                            }
                    }
                }
            } else {
                Image("profileIcon")
                    .resizable()
                    .frame(width: 100, height: 100)
                   // .cornerRadius(20)
                    .clipped()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 1)
                             )
                    .onTapGesture {
                        showImagePicker = true
                    }
            }
            
            VStack(alignment: .leading) {
                           Text(viewModel.name)
                               .font(.title2)
                               .offset(x: 55)
                           Spacer()
                           RatingBar(rating: $rating)
                       }
                       .padding(.leading, 10)
                   }
                   .padding()
               }
           }

#Preview {
    ProfileView(userID: "exampleUserID", isEditable: false)
}
