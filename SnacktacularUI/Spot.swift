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

extension Spot {
    static var preview: Spot {
        let newSpot = Spot(id: "1", name: "Boston Public Market", address: "Boston, MA")
        return newSpot
    }
}
