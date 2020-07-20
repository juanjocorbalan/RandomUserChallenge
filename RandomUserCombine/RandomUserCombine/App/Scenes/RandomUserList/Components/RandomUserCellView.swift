//
//  RandomUserCellView.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit
import Combine

class RandomUserCellView: UICollectionViewCell {
    
    var cancellables = Set<AnyCancellable>()

    static var storyboardID: String {
        return String(describing: Self.self)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var removeButton: UIButton!
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        avatarImageView.image = nil
        avatarImageView.alpha = 0.0
        backgroundImageView.image = nil
        backgroundImageView.alpha = 0.0
        nameLabel.text = nil
        cityLabel.text = nil
        setupUI()
    }
    
    func setup(with viewModel: RandomUserCellViewModel, imageFetcher: ImageFetcher = ImageFetcher.shared) {
    
        setupUI()
        
        viewModel.avatar
            .filter { $0.0 != nil }
            .flatMap { avatarData -> AnyPublisher<UIImage?, Never> in
                imageFetcher.fetchImage(from: avatarData.0!, for: avatarData.1)
            }.sink(receiveValue: { [weak self] image in
                guard let strongSelf = self else { return }
                strongSelf.showImage(image: image, in: strongSelf.avatarImageView)
            })
            .store(in: &cancellables)

        viewModel.background
            .filter { $0.0 != nil }
            .flatMap { backgroundData -> AnyPublisher<UIImage?, Never> in
                imageFetcher.fetchImage(from: backgroundData.0!, for: backgroundData.1)
            }.sink(receiveValue: { [weak self] image in
                guard let strongSelf = self else { return }
                strongSelf.showImage(image: image, in: strongSelf.backgroundImageView)
            })
            .store(in: &cancellables)

        viewModel.name
            .map { $0 }
            .assign(to: \.text, on: nameLabel)
            .store(in: &cancellables)
        
        viewModel.city
            .map { $0 }
            .assign(to: \.text, on: cityLabel)
            .store(in: &cancellables)
        
        removeButton.publisher(for: .touchUpInside)
            .sink(receiveValue: { _ in
                viewModel.removeSelected.send(())
            })
            .store(in: &cancellables)

    }
    
    private func setupUI() {
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        cityLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2.0
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth = Styles.Constants.avatarBorderWidth
        avatarImageView.layer.borderColor = Styles.Colors.accentColor.cgColor
        containerView.layer.cornerRadius = Styles.Constants.defaultCornerRadius
        containerView.layer.masksToBounds = true
        blurView.layer.cornerRadius = Styles.Constants.defaultCornerRadius
        blurView.layer.masksToBounds = true
        containerView.layer.borderColor = Styles.Colors.accentColor.cgColor
        containerView.layer.borderWidth = Styles.Constants.userBorderWidth
        removeButton.tintColor = Styles.Colors.accentColor
    }
    
    private func showImage(image: UIImage?, in imageView: UIImageView) {
        imageView.alpha = 0.0
        imageView.image = image
        let animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            imageView.alpha = 1.0
        })
        animator.startAnimation()
    }
}
