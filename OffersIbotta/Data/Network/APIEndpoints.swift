//
//  APIEndpoints.swift
//  OffersIbotta
//
//  Created by Mariia on 6/19/23.
//

import Foundation

struct APIEndpoints {
    static func getOffers() -> Endpoint {
        return Endpoint(path: .fileName("Offers.json"))
    }
    
    static func getOfferImage(path: String) -> Endpoint {
        return Endpoint(path: .urlPath(path), responseDecoder: RawDataResponseDecoder())
    }
}
