import SwiftUI

struct ImageCarouselView: View {
    var images: [URL]

    var body: some View {
        TabView {
            ForEach(images, id: \.self) { imageUrl in
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        Color("background")
                            .frame(height: 250)
                            .cornerRadius(8)
                            .opacity(0.5)
                            .transition(.opacity)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(8)
                            .opacity(1)
                            .transition(.opacity)
                            .animation(.easeIn(duration: 0.5), value: image)
                    case .failure:
                        Image("error_loading_image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(8)
                            .opacity(1)
                            .transition(.opacity)
                            .animation(.easeIn(duration: 0.5), value: imageUrl)
                    @unknown default:
                        Color("background")
                            .frame(height: 250)
                            .cornerRadius(8)
                            .opacity(0.5)
                            .transition(.opacity)
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(height: 250)
    }
}
