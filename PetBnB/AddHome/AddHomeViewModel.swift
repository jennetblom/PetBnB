import SwiftUI
import Combine
import PhotosUI

class AddHomeViewModel: ObservableObject {
    @Published var beds: String = "hämta från fb"
    @Published var rooms: String = ""
    @Published var city: String = ""
    @Published var additionalInfo: String = ""
    @Published var animalCount: Int = 1
    @Published var animalType: [String] = [""]
    @Published var animalAge: [String] = [""]
    @Published var animalInfo: [String] = [""]
    @Published var selectedImages: [UIImage] = []
    @Published var isShowingImagePicker: Bool = false

    func addAnimal() {
        animalCount += 1
        animalType.append("")
        animalAge.append("")
        animalInfo.append("")
    }
}
