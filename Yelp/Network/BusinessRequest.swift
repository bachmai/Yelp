//
//  BusinessRequest.swift
//  Yelp
//
//  Created by Bach Mai on 3/24/22.
//

struct YelpTokenConstants {
    static let clientID = "WDfPljaLr572MsO7GCHDAw"
    static let apiKey = "ySuNrwI9UgAMW0FLOhfzBVNoxtLtzV2RzdxPRQGQ37EJZKHumDnZH79vsJ-a1RA_4mrID3tie67FQxB28idVFdq07rDZy9Wr_J0NBLTMYG-ALLFK4-_UU5g1wBI9YnYx"
    static let headers = ["Authorization": "Bearer " + YelpTokenConstants.apiKey]
}

struct NetworkURLConstants {
    static let businessSearch = "https://api.yelp.com/v3/businesses/search"
    static let businessDetails = "https://api.yelp.com/v3/businesses/"
}

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
    
    struct LocationDetailsObj: Decodable {
        var display_address: [String]?
    }
}
