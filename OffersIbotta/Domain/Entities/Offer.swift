//
//  Offer.swift
//  OffersIbotta
//
//  Created by Mariia on 6/14/23.
//

import Foundation

struct Offer: Equatable, Codable {
    typealias Identifier = Int
    
    let id: Identifier
    let urlPath: String?
    let name: String
    let description: String
    let terms: String
    let currentValue: String
}
