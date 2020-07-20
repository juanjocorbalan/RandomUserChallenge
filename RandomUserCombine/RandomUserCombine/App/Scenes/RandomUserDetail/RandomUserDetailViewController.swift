//
//  RandomUserDetailViewController.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit
import Combine

class RandomUserDetailViewController: UIViewController, StoryboardInitializable {
    
    private var cancellables = Set<AnyCancellable>()
    private var closeItem = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: nil)
    
    var viewModel: RandomUserDetailViewModel!
    var imageFetcher: ImageFetcher!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var blurView1: UIVisualEffectView!
    @IBOutlet weak var blurView2: UIVisualEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        navigationController?.presentationController?.delegate = self
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupUI()
    }

    private func setupUI() {
        genderLabel.font = UIFont.preferredFont(forTextStyle: .body)
        cityLabel.font = UIFont.preferredFont(forTextStyle: .body)
        emailLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionTextView.font = UIFont.preferredFont(forTextStyle: .body)
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2.0
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth = Styles.Constants.avatarBorderWidth
        avatarImageView.layer.borderColor = Styles.Colors.accentColor.cgColor
        descriptionTextView.textContainerInset = .zero
        blurView1.layer.cornerRadius = Styles.Constants.defaultCornerRadius
        blurView1.layer.masksToBounds = true
        blurView1.layer.borderWidth = Styles.Constants.userBorderWidth
        blurView1.layer.borderColor = Styles.Colors.accentColor.cgColor
        blurView2.layer.cornerRadius = Styles.Constants.defaultCornerRadius
        blurView2.layer.masksToBounds = true
        blurView2.layer.borderWidth = Styles.Constants.userBorderWidth
        blurView2.layer.borderColor = Styles.Colors.accentColor.cgColor
        backgroundImageView.alpha = 0.5
        navigationItem.rightBarButtonItem = closeItem
    }
    
    private func setupBindings() {
        
        viewModel.$avatar
            .filter { $0.0 != nil }
            .flatMap { [weak self] avatarData -> AnyPublisher<UIImage?, Never> in
                guard let strongSelf = self else { return Just(nil).eraseToAnyPublisher()  }
                return strongSelf.imageFetcher.fetchImage(from: avatarData.0!, for: avatarData.1)
            }.sink(receiveValue: { [weak self] image in
                guard let strongSelf = self else { return }
                strongSelf.showImage(image: image, in: strongSelf.avatarImageView)
            })
            .store(in: &cancellables)

        viewModel.$background
            .filter { $0.0 != nil }
            .flatMap { [weak self] backgroundData -> AnyPublisher<UIImage?, Never> in
                guard let strongSelf = self else { return Just(nil).eraseToAnyPublisher()  }
                return strongSelf.imageFetcher.fetchImage(from: backgroundData.0!, for: backgroundData.1)
            }.sink(receiveValue: { [weak self] image in
                guard let strongSelf = self else { return }
                strongSelf.showImage(image: image, in: strongSelf.backgroundImageView)
            })
            .store(in: &cancellables)

        viewModel.$name
            .map { $0 }
            .assign(to: \.title, on: navigationItem)
            .store(in: &cancellables)
        
        viewModel.$gender
            .map { $0 }
            .assign(to: \.text, on: genderLabel)
            .store(in: &cancellables)

        viewModel.$city
            .map { $0 }
            .assign(to: \.text, on: cityLabel)
            .store(in: &cancellables)

        viewModel.$email
            .map { $0 }
            .assign(to: \.text, on: emailLabel)
            .store(in: &cancellables)

        viewModel.$description
            .map { $0 }
            .assign(to: \.text, on: descriptionTextView)
            .store(in: &cancellables)
        
        closeItem.publisher
            .sink(receiveValue: { [weak self] _ in
                self?.viewModel.close.send(())
            })
            .store(in: &cancellables)
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

extension RandomUserDetailViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewModel.close.send(())
    }
}
