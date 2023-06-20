//
//  OfferCollectionViewCell.swift
//  OffersIbotta
//
//  Created by Mariia on 6/14/23.
//

import UIKit
import SkeletonView

final class OfferCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: OfferCollectionViewCell.self)
    
    private var viewModel: OffersListItemViewModel!
    private var offerImagesRepository: OfferImagesRepository?
    
    private lazy var imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        
        return imageView
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.textColor = Constants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.subtitleFont
        label.textColor = Constants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
       super.init(frame: frame)
        
        setupViews()
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
       super.prepareForReuse()
       
       self.imageView.image = nil
   }
    
    func fill(
        with viewModel: OffersListItemViewModel,
        offerImagesRepository: OfferImagesRepository?
    ) {
        self.viewModel = viewModel
        self.offerImagesRepository = offerImagesRepository

        nameLabel.text = viewModel.title
        valueLabel.text = viewModel.value
        
        observe()
        updateOfferImage()
        configureLikeButton()
        imageBackgroundView.showSkeleton()
    }
}

private extension OfferCollectionViewCell {
    
    func reconfigureLikeButton() {
        guard viewModel.hasIsFavoriteChanged else { return }
        configureLikeButton()
    }
    
    func configureLikeButton() {
        if viewModel.isFavorite {
            likeButton.setImage(CommonImages.selectedLikeButtonImage, for: .normal)
        } else {
            likeButton.setImage(CommonImages.deselectedLikeButtonImage, for: .normal)
        }
    }
    
    func updateOfferImage() {
        guard let offerImagePath = viewModel.offerImagePath else {
            self.imageView.hideSkeleton()
            imageView.image = CommonImages.offerImagePlaceholderImage
            return
        }
        offerImagesRepository?.fetchImage(with: offerImagePath) { [weak self] result in
            guard let self = self, case let .success(image) = result else { return }
            self.imageView.hideSkeleton()
            self.imageView.image = image
        }
    }
    
    
    func observe() {
        viewModel.favorites.observe(on: self) { [weak self] _ in
            self?.reconfigureLikeButton()
        }
    }
    
    func setupViews() {
        contentView.addSubview(imageBackgroundView)
        contentView.addSubview(valueLabel)
        contentView.addSubview(nameLabel)
        imageBackgroundView.addSubview(imageView)
        imageBackgroundView.addSubview(likeButton)
        
        // imageBackgroundView layout
        NSLayoutConstraint.activate([
            imageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        // amountLabel layout
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: imageBackgroundView.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        // nameLabel layout
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 3),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // imageView layout
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageBackgroundView.topAnchor, constant: Constants.imageViewInsets.top),
            imageView.bottomAnchor.constraint(equalTo: imageBackgroundView.bottomAnchor, constant: Constants.imageViewInsets.bottom),
            imageView.leadingAnchor.constraint(equalTo: imageBackgroundView.leadingAnchor, constant: Constants.imageViewInsets.left),
            imageView.trailingAnchor.constraint(equalTo: imageBackgroundView.trailingAnchor, constant: Constants.imageViewInsets.right)
        ])
        
        // likeButton layout
        
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: Constants.likeButtonSize.width),
            likeButton.heightAnchor.constraint(equalToConstant: Constants.likeButtonSize.height),
            likeButton.trailingAnchor.constraint(equalTo: imageBackgroundView.trailingAnchor, constant: -3),
            likeButton.topAnchor.constraint(equalTo: imageBackgroundView.topAnchor, constant: 3)
        ])
    }
    
    @objc func likeButtonTapped() {
        viewModel.toggleFavoriteState()
        
        UIView.animate(withDuration: 0.7) {
            self.configureLikeButton()
        }
    }
}

private extension OfferCollectionViewCell {
    enum Constants {
        static let titleFont = UIFont(name: "AvenirNext-DemiBold", size: 12)
        static let subtitleFont = UIFont(name: "AvenirNext-Regular", size: 11)
        static let textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        static let likeButtonSize = CGSize(width: 25, height: 25)
        static let imageViewInsets = UIEdgeInsets(top: 6, left: 6, bottom: -6, right: -6)
    }
}
