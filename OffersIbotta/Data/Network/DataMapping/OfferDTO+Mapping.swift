//
//  OfferDTO+Mapping.swift
//  OffersIbotta
//
//  Created by Mariia on 6/19/23.
//

import Foundation

struct OfferDTO: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case url
        case name
        case description
        case terms
        case currentValue = "current_value"
    }
    
    let id: String
    let url: String?
    let name: String
    let description: String
    let terms: String
    let currentValue: String
}

// MARK: - Mappings to Domain

extension OfferDTO {
    func toDomain() -> Offer {
        return .init(
            id: Int(id)!,
            urlPath: url,
            name: name,
            description: description,
            terms: terms,
            currentValue: currentValue
        )
    }
}
