//
//  OffersListItemViewModel.swift
//  OffersIbotta
//
//  Created by Mariia on 6/17/23.
//

import UIKit

protocol OffersListItemViewModel {
    var offerImage: Observable<UIImage?> { get }
    var offerImagePath: String? { get }
    var title: String { get }
    var value: String { get }
    var isFavorite: Bool { get }
    var hasIsFavoriteChanged: Bool { get }
    var favorites: Observable<Set<Int>> { get }
    
    func toggleFavoriteState()
}

final class DefaultOffersListItemViewModel: OffersListItemViewModel {

    let title: String
    let value: String
    let offerImagePath: String?
    let offerImage: Observable<UIImage?> = Observable(nil)
    
    // TODO: Idially would be to make observable isFavorite but not the whole list of favorites
    var favorites: Observable<Set<Int>> {
        FavoritesManager.shared.favorites
    }
    
    // Prev value to check whether value changed
    private var isFavoriteOldValue: Bool
    private let id: Int
    
    var isFavorite: Bool {
        let newValue = FavoritesManager.shared.isFavorite(id)
        isFavoriteOldValue = newValue
        return newValue
    }
    
    var hasIsFavoriteChanged: Bool {
        isFavoriteOldValue != isFavorite
    }
    
    init(
        offer: Offer
    ) {
        self.id = offer.id
        self.title = offer.name
        self.value = offer.currentValue
        self.offerImagePath = offer.urlPath
        isFavoriteOldValue = FavoritesManager.shared.isFavorite(id)
    }
    
    func toggleFavoriteState() {
        FavoritesManager.shared.toggleFavorite(id)
    }
}
