import SwiftUI
import Firebase
import FirebaseAuth

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    var userID: String
    var isEditable: Bool = true
    @EnvironmentObject var tabViewModel: TabViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedSegment: Int
    @State var hasChanges: Bool = false
    @State var isLoading: Bool = true
    @State var ignoreChanges: Bool = true
    @State private var showImagePicker = false
    @State private var selectedProfileImage: UIImage?
    @State private var selectedImages = [UIImage]()
    @State private var hasImageChanged = false

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

            profileHeaderWithImageAndStars(rating: $viewModel.rating, showImagePicker: $showImagePicker, selectedImage: $selectedProfileImage, profileImageUrl: $viewModel.profilePictureUrl, hasImageChanged: $hasImageChanged, isEditable: isEditable)

            if selectedSegment == 0 {
                HomeOwnerView(hasChanges: $hasChanges, isLoading: $isLoading, ignoreChanges: $ignoreChanges, isEditable: isEditable)
            } else {
                HomeGuestView(hasChanges: $hasChanges, isLoading: $isLoading, ignoreChanges: $ignoreChanges, isEditable: isEditable)
            }
            Spacer()

            if (hasChanges || hasImageChanged) && isEditable {
                    Button(action: {
                        hasChanges = false
                        hasImageChanged = false
                        saveProfile()
                    }) {
                        Text("Spara")
                            .frame(width: 220, height: 40)
                            .background(Color("primary"))
                            .foregroundColor(.black)
                            .cornerRadius(10.0)
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        .sheet(isPresented: $showImagePicker) {
            ProfileImagePicker(selectedImages: $selectedImages, selectedSingleImage: $selectedProfileImage, isSingleImage: true)
                .onChange(of: selectedProfileImage) { _ in
                    hasImageChanged = true
                }
        }
        .onAppear {
            viewModel.fetchUserProfileFromFirebase(for: userID) {
                isLoading = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    ignoreChanges = false
                }
            }
        }
        .onDisappear {
            if !tabViewModel.isProfileViewPresented {
                presentationMode.wrappedValue.dismiss()
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
                    hasImageChanged = false
                }
            }
        } else {
            viewModel.saveUserProfileToFirebase()
            hasChanges = false
            hasImageChanged = false
        }
    }
}

struct profileHeaderWithImageAndStars: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Binding var rating: Double
    @Binding var showImagePicker: Bool
    @Binding var selectedImage: UIImage?
    @Binding var profileImageUrl: URL?
    @Binding var hasImageChanged: Bool
    var isEditable: Bool
    
    var body: some View {
        HStack (alignment: .center) {
            ProfileImage(selectedImage : $selectedImage, profileImageUrl: $profileImageUrl, showImagePicker: $showImagePicker, isEditable: isEditable)
            
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.title2)
                RatingBar(rating: $rating, viewModel: _viewModel)
            }
            .padding(.leading, 10)
        }
        .padding()
    }
}
struct ProfileImage: View {
    @Binding var selectedImage: UIImage?
    @Binding var profileImageUrl: URL?
    @Binding var showImagePicker: Bool
    var isEditable: Bool
    
    var body: some View {
        if let selectedImage = selectedImage {
            Image(uiImage: selectedImage)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(20)
                .clipped()
                .onTapGesture {
                    showImagePicker = isEditable
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
                            showImagePicker = isEditable
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
                            showImagePicker = isEditable
                        }
                @unknown default:
                    Image("profileIcon")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            showImagePicker = isEditable
                        }
                }
            }
        } else {
            Image("profileIcon")
                .resizable()
                .frame(width: 100, height: 100)
                .clipped()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .onTapGesture {
                    showImagePicker = isEditable
                }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userID: "exampleUserID", isEditable: false)
    }
}
