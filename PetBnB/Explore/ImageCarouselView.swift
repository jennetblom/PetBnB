import SwiftUI

struct ImageCarouselView: View {
    var images: [URL]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { imageUrl in
                AsyncImage(url: imageUrl) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(8)
                    } else if phase.error != nil {
                        Image("error_loading_image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(8)
                    } else {
                        Color("background")
                            .frame(height: 250)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(height: 250)
    }
}
