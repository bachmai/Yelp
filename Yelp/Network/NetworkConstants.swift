//
//  NetworkConstants.swift
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
