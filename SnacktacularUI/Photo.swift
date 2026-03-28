//
//  Photo.swift
//  SnacktacularUI
//
//  Created by Zimeng Yang on 3/28/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class Photo: Identifiable, Codable {
    @DocumentID var id: String?
    var imageURLString = ""
    var description = ""
    var reviewer: String = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    init(id: String? = nil, imageURLString: String = "", description: String = "", reviewer: String = (Auth.auth().currentUser?.email ?? ""), postedOn: Date = Date()) {
        self.id = id
        self.imageURLString = imageURLString
        self.description = description
        self.reviewer = reviewer
        self.postedOn = postedOn
    }
}

extension Photo {
    static var preview: Photo {
        let newPhoto = Photo(id: "1", imageURLString: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Pizza-3007395.jpg/960px-Pizza-3007395.jpg", description: "Yummy Pizza", reviewer: "little@caesars.com", postedOn: Date())
        return newPhoto
    }
}
