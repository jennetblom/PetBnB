import SwiftUI

struct ProfileView: View {
    @State private var selectedSegment = 0
    @StateObject var viewModel = ProfileViewModel()
    @State var hasChanges: Bool = true
    @State var isLoading: Bool = false
    
    @State private var showImagePicker = false
    @State private var selectedProfileImage: UIImage?
    @State private var selectedImages = [UIImage]()
    
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
            
            profileHeaderWithImageAndStars(rating: $viewModel.rating, showImagePicker: $showImagePicker, selectedImage: $selectedProfileImage, profileImageUrl: $viewModel.profilePictureUrl)
            
            if selectedSegment == 0 {
                HomeOwnerView(hasChanges: $hasChanges, isLoading: $isLoading)
            } else {
                HomeGuestView()
            }
            Spacer()
            
            if hasChanges {
                Button("Spara") {
                    saveProfile()
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
                isLoading = true
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImages: $selectedImages, selectedSingleImage: $selectedProfileImage, isSingleImage: true)
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
        HStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
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
                            .clipShape(Circle())
                            .onTapGesture {
                                showImagePicker = true
                            }
                    case .failure:
                        Image("catimage")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .onTapGesture {
                                showImagePicker = true
                            }
                    @unknown default:
                        Image("catimage")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .onTapGesture {
                                showImagePicker = true
                            }
                    }
                }
            } else {
                Image("catimage")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .onTapGesture {
                        showImagePicker = true
                    }
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.name)
                        .font(.title2)
                        .offset(x: 55)
                    Spacer() // Ensure the text grows to the right
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
