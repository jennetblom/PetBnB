//
//  ImagePicker.swift
//  PetBnB
//
//  Created by Ina Burström on 2024-05-21.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Binding var selectedSingleImage: UIImage?
    var isSingleImage: Bool

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = isSingleImage ? 1 : 0
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            let group = DispatchGroup()

            for result in results {
                group.enter()
                let provider = result.itemProvider

                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { (image, error) in
                        DispatchQueue.main.async {
                            if let uiImage = image as? UIImage {
                                if self.parent.isSingleImage {
                                    self.parent.selectedSingleImage = uiImage
                                } else {
                                    self.parent.selectedImages.append(uiImage)
                                }
                            }
                            group.leave()
                        }
                    }
                } else {
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                // Handling after all images are loaded
            }
        }
    }
}
