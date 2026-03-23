//
//  Spot.swift
//  SnacktacularUI
//
//  Created by Zimeng Yang on 3/22/26.
//

import Foundation
import FirebaseFirestore

struct Spot: Codable, Identifiable {
    @DocumentID var id: String?
    var name = ""
    var address = ""
}
