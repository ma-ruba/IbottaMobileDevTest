//
//  Endpoint.swift
//  OffersIbotta
//
//  Created by Mariia on 6/19/23.
//

import Foundation

enum PathType {
    case fileName(String)
    case urlPath(String)
}

class Endpoint {
    let path: PathType
    let responseDecoder: ResponseDecoder
    
    init(
        path: PathType,
        responseDecoder: ResponseDecoder = JSONResponseDecoder()
    ) {
        self.path = path
        self.responseDecoder = responseDecoder
    }
}
