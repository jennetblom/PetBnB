//
//  RatingBarView.swift
//  PetBnB
//
//  Created by Jennet on 2024-05-22.
//

import Foundation
import SwiftUI

struct StarView : View {
    var filled : Bool
    var size : CGFloat = 20
    
    var body: some View {
        Image(systemName: filled ? "star.fill" : "star")
            .resizable()
            .frame(width: size, height: size)
            .foregroundColor(filled ? .yellow : .gray)
    }
}
struct RatingBar: View {
    @Binding var rating: Double
    var maximumRating: Int = 5
    var starSize: CGFloat = 24
    @EnvironmentObject var viewModel: ProfileViewModel

    var body: some View {
        HStack {
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                StarView(filled: number <= Int(rating), size: starSize)
                    .onTapGesture {
                        let temporaryRating = rating // Save current rating
                        rating = Double(number) // Update rating to temporary rating
                        updateRating(newRating: Double(number))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            rating = temporaryRating // Restore rating to original value after 0.5s
                        }
                    }
            }
        }
    }

    func updateRating(newRating: Double) {
        viewModel.ratingCount += 1
        let totalRating = rating * Double(viewModel.ratingCount - 1)
        rating = (totalRating + newRating) / Double(viewModel.ratingCount)
        viewModel.saveUserProfileToFirebase()
    }
}
