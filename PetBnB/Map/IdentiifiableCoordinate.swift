//
//  IdentiifiableCoordinate.swift
//  PetBnB
//
//  Created by Weda on 2024-05-29.
//

import Foundation
import CoreLocation

struct IdentiifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
