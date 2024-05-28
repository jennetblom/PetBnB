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
    @Binding var rating: Int
    var maximumRating: Int = 5
    var starSize: CGFloat = 24
    
    var body: some View {
        HStack {
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                StarView(filled: number <= rating, size: starSize)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
}
