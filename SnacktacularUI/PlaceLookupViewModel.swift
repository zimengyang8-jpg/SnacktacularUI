//
//  PlaceLookupViewModel.swift
//  LocationAndPlaceLookup
//
//  Created by Zimeng Yang on 3/28/26.
//

import Foundation
import MapKit

@Observable
@MainActor

class PlaceLookupViewModel {
    var places: [Place] = []
    
    func search(text: String, region: MKCoordinateRegion) async throws {
        let searchRequest = MKLocalSearch.Request()
        // pass in search text into the request
        searchRequest.naturalLanguageQuery = text
        // establish a search region
        searchRequest.region = region
        // now create the search object that performs the search
        let search = MKLocalSearch(request: searchRequest)
        // run the search
        let response = try await search.start()
        if response.mapItems.isEmpty {
            throw NSError(domain: "No results", code: -1, userInfo: [NSLocalizedDescriptionKey: "⁉️ No location found"])
        }
        self.places = response.mapItems.map(Place.init)
    }
}
