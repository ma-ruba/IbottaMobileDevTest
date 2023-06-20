//
//  OffersListViewModel.swift
//  OffersIbotta
//
//  Created by Mariia on 6/17/23.
//

import Foundation

// TODO: Add Pagination

struct OffersListViewModelActions {
    let showOfferDetais: (Offer) -> Void
}

protocol OffersListViewModel {
    var items: Observable<[OffersListItemViewModel]> { get }
    
    func viewDidLoad()
    func refresh(completion: (() -> Void)?)
    func didSelectItem(at index: Int)
}

final class DefaultOffersListViewModel: OffersListViewModel {
    let items: Observable<[OffersListItemViewModel]> = Observable([])
    private var offers: [Offer] = []
    
    private let actions: OffersListViewModelActions?
    private let offersRepository: OffersRepository?
    
    // MARK: - Init
    
    init(
        actions: OffersListViewModelActions?,
        offersRepository: OffersRepository?
    ) {
        self.actions = actions
        self.offersRepository = offersRepository
    }
    
    func viewDidLoad() {
        loadData(completion: nil)
    }
    
    func refresh(completion: (() -> Void)?) {
        loadData(completion: completion)
    }
    
    func didSelectItem(at index: Int) {
        actions?.showOfferDetais(offers[index])
    }
}

private extension DefaultOffersListViewModel {
    func loadData(completion: (() -> Void)?) {
        offersRepository?.fetchOffersList(completion: { [weak self] result in
            guard let self, case let .success(offers) = result else { return }
            self.items.value = offers.map { DefaultOffersListItemViewModel(offer: $0) }
            self.offers = offers
            completion?()
        })
    }
}
