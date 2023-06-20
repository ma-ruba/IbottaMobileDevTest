//
//  OfferDetailsViewController.swift
//  OffersIbotta
//
//  Created by Mariia on 6/19/23.
//

import UIKit

final class OfferDetailsViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.currentValue
        label.font = Constants.titleFont
        label.textColor = Constants.textColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.name
        label.font = Constants.subtitleFont
        label.textColor = Constants.textColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Description: ", attributes: [NSAttributedString.Key.font: Constants.smallTitleFont])
        attributedText.append(NSAttributedString(string: viewModel.description , attributes: [NSAttributedString.Key.font: Constants.regularFont]))
        label.attributedText = attributedText
        label.textColor = Constants.textColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Terms: ", attributes: [NSAttributedString.Key.font: Constants.smallTitleFont])
        attributedText.append(NSAttributedString(string: viewModel.terms, attributes: [NSAttributedString.Key.font: Constants.regularFont]))
        label.attributedText = attributedText
        label.textColor = Constants.textColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var viewModel: OfferDetailsViewModel
    
    // MARK: - Init
    
    init(
        viewModel: OfferDetailsViewModel
    ) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
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

private extension OfferDetailsViewController {
    
    enum Constants {
        static let titleFont = UIFont(name: "AvenirNext-DemiBold", size: 25)
        static let subtitleFont = UIFont(name: "AvenirNext-Regular", size: 20)
        static let regularFont = UIFont(name: "AvenirNext-Regular", size: 16)
        static let smallTitleFont = UIFont(name: "AvenirNext-DemiBold", size: 18)
        static let textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        static let imageViewInsets = UIEdgeInsets(top: 6, left: 6, bottom: -6, right: -6)
        static let textSideInset: CGFloat = 12
    }
    
    func observe() {
        viewModel.offerImage.observe(on: self) { [weak self] in self?.imageView.image = $0 }
    }
    
    func setupUI() {
        configureNavigationItem()
        
        view.backgroundColor = .white
        navigationItem.title = viewModel.name
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageBackgroundView)
        contentView.addSubview(valueLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(termsLabel)
        imageBackgroundView.addSubview(imageView)
        
        // scrollView layout
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
        
        
        // contentView layout
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // imageBackgroundView layout
        NSLayoutConstraint.activate([
            imageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageBackgroundView.heightAnchor.constraint(equalToConstant: view.frame.height * 1 / 3)
        ])
        
        // imageView layout
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageBackgroundView.topAnchor, constant: Constants.imageViewInsets.top),
            imageView.bottomAnchor.constraint(equalTo: imageBackgroundView.bottomAnchor, constant: Constants.imageViewInsets.bottom),
            imageView.leadingAnchor.constraint(equalTo: imageBackgroundView.leadingAnchor, constant: Constants.imageViewInsets.left),
            imageView.trailingAnchor.constraint(equalTo: imageBackgroundView.trailingAnchor, constant: Constants.imageViewInsets.right)
        ])
        
        // amountLabel layout
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: imageBackgroundView.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.textSideInset),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.textSideInset)
        ])
        
        // nameLabel layout
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 3),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.textSideInset),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.textSideInset)
        ])
        
        // descriptionLabel layout
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.textSideInset),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.textSideInset)
        ])
        
        // termsLabel layout
        NSLayoutConstraint.activate([
            termsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 3),
            termsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.textSideInset),
            termsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.textSideInset),
            termsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureNavigationItem() {
        navigationController?.navigationBar.tintColor = .black
        
        var likeBarItem: UIBarButtonItem
        if viewModel.isFavorite {
            likeBarItem = UIBarButtonItem(image: CommonImages.selectedLikeButtonImage, style: .plain, target: self, action: #selector(likeButtonTapped))
        } else {
            likeBarItem = UIBarButtonItem(image: CommonImages.deselectedLikeButtonImage, style: .plain, target: self, action: #selector(likeButtonTapped))
        }
        
        navigationItem.rightBarButtonItems = [likeBarItem]
    }
    
    @objc func likeButtonTapped() {
        viewModel.toggleFavoriteState()
        
        UIView.animate(withDuration: 0.7) {
            self.configureNavigationItem()
        }
    }
}
