//
//  OffersListViewController.swift
//  OffersIbotta
//
//  Created by Mariia on 6/14/23.
//

import UIKit

final class OffersListViewController: UICollectionViewController {
    
    var viewModel: OffersListViewModel
    
    private var offerImagesRepository: OfferImagesRepository?
    private let refreshControl = UIRefreshControl()
    
    
    // MARK: - Init
    
    init(
        viewModel: OffersListViewModel,
        offerImagesRepository: OfferImagesRepository?
    ) {
        self.viewModel = viewModel
        self.offerImagesRepository = offerImagesRepository
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 24
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.viewDidLoad()
        setupUI()
        observe()
    }
}

private extension OffersListViewController {
    
    func observe() {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
    }
    
    func updateItems() {
        collectionView.reloadData()
    }
    
    func setupUI() {
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        // Registration
        collectionView.register(OfferCollectionViewCell.self, forCellWithReuseIdentifier: OfferCollectionViewCell.reuseIdentifier)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OffersListViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OfferCollectionViewCell.reuseIdentifier, for: indexPath) as? OfferCollectionViewCell else {
            assertionFailure("Cannot dequeue reusable cell \(OfferCollectionViewCell.self) with reuseIdentifier: \(OfferCollectionViewCell.reuseIdentifier)")
            return UICollectionViewCell()
        }
        
        cell.fill(with: viewModel.items.value[indexPath.item], offerImagesRepository: offerImagesRepository)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            
        let  widthPerItem = (collectionView.frame.width) / 2 - flowLayout.minimumInteritemSpacing
        return .init(width: widthPerItem - 8, height: widthPerItem * 2 / 3 + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.collectionViewInsets
    }
}

private extension OffersListViewController {
    
    @objc private func refresh() {
        refreshControl.beginRefreshing()
        viewModel.refresh { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    enum Constants {
        static let collectionViewInsets = UIEdgeInsets(top: 20, left: 12, bottom: 20, right: 12)
    }
}
