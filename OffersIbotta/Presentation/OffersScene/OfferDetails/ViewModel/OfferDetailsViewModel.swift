//
//  OfferDetailsViewModel.swift
//  OffersIbotta
//
//  Created by Mariia on 6/19/23.
//

import UIKit

protocol OfferDetailsViewModel {
    var offerImage: Observable<UIImage?> { get }
    var name: String { get }
    var description: String { get }
    var terms: String { get }
    var currentValue: String { get }
    var isFavorite: Bool { get }
    
    func viewDidLoad()
    func toggleFavoriteState()
}

final class DefaultOfferDetailsViewModel: OfferDetailsViewModel {
    
    let offerImage: Observable<UIImage?> = Observable(nil)
    
    let name: String
    let description: String
    let terms: String
    let currentValue: String
    
    private let urlPath: String?
    private let id: Int
    private let offerImagesRepository: OfferImagesRepository
    
    var isFavorite: Bool {
        FavoritesManager.shared.isFavorite(id)
    }
    
    // MARK: - Init
    
    init(
        offer: Offer,
        offerImagesRepository: OfferImagesRepository
    ) {
        self.id = offer.id
        self.name = offer.name
        self.urlPath = offer.urlPath
        self.currentValue = offer.currentValue
        self.description = offer.description
        self.terms = offer.terms
        self.offerImagesRepository = offerImagesRepository
    }
    
    func viewDidLoad() {
        loadImage()
    }
    
    func toggleFavoriteState() {
        FavoritesManager.shared.toggleFavorite(id)
    }
}

private extension DefaultOfferDetailsViewModel {
    func loadImage() {
        guard let urlPath else {
            self.offerImage.value = CommonImages.offerImagePlaceholderImage
            return
        }
        
        offerImagesRepository.fetchImage(with: urlPath) { [weak self] result in
            guard let self = self, case let .success(image) = result else { return }
            self.offerImage.value = image
        }
    }
}
