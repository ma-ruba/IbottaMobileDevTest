//
//  CommonImages.swift
//  OffersIbotta
//
//  Created by Mariia on 6/19/23.
//

import UIKit

enum CommonImages {
    static let selectedLikeButtonImage = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
    static let deselectedLikeButtonImage = UIImage(systemName: "heart")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    static let offerImagePlaceholderImage = UIImage(systemName: "photo")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
}
