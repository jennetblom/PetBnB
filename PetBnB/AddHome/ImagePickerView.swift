//
//  ImagePickerView.swift
//  PetBnB
//
//  Created by Ina Burström on 2024-05-22.
//

import SwiftUI

struct ImagePickerView: View {
    @Binding var selectedImages: [UIImage]
    @Binding var isShowingImagePicker: Bool
    

    var body: some View {
        VStack {
            if !selectedImages.isEmpty {
                VStack {
                    TabView {
                        ForEach(selectedImages, id: \.self) { uiImage in
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(8)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .frame(height: 200)

                    Button(action: {
                        isShowingImagePicker = true
                    }) {
                        Text("Lägg till fler bilder")
                            .font(.headline)
                            .foregroundStyle(Color("secondary"))
                    }
                    .padding(.top, 10)
                }
            } else {
                Button(action: {
                    isShowingImagePicker = true
                }) {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                            .cornerRadius(8)
                        
                        VStack {
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color("secondary"))
                            Text("Lägg till bilder")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(selectedImages: $selectedImages, selectedSingleImage: .constant(nil), isSingleImage: false)
        }
    }
}
