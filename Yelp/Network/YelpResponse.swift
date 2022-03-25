//
//  YelpResponse.swift
//  Yelp
//
//  Created by Bach Mai on 3/25/22.
//

import Foundation

struct BusinessSearchResponse: Decodable {
    var total: Int
    var businesses: [BusinessDetailObj]
    var region: CenterObj?
    
    struct CenterObj: Decodable {
        var center: LocationObj?
    }
    
    struct LocationObj: Decodable {
        var latitude: Double?
        var longitude: Double?
    }
}
struct BusinessDetailObj: Decodable {
    var rating: Double
    var price: String?
    var phone: String?
    var id: String
    var alias: String?
    var is_closed: Bool?
    var name: String
    var distance: Double?
    var image_url: String?
}

struct BusinessDetailsResponse: Decodable {
    var id: String
    var name: String
    var display_phone: String?
    var review_count: Int?
    var rating: Double
    var photos: [String]?
    var price: String?
    var location: LocationDetailsObj
    var hours: [OpeningHoursObj]
    
    struct LocationDetailsObj: Decodable {
        var display_address: [String]?
    }
    
    struct OpeningHoursObj: Decodable {
        var is_open_now: Bool?
    }
}
