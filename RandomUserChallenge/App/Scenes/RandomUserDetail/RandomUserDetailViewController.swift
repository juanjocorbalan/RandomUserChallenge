//
//  RandomUserDetailViewController.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit
import RxSwift

class RandomUserDetailViewController: UIViewController, StoryboardInitializable {
    
    private let disposeBag = DisposeBag()
    private let closeItem = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: nil)
    
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
        
        viewModel.avatar
            .filter { $0.0 != nil }
            .flatMap { [weak self] avatarData -> Observable<UIImage?> in
                guard let strongSelf = self else { return Observable.empty() }
                return strongSelf.imageFetcher.fetchImage(from: avatarData.0!, for: avatarData.1)
            }
            .subscribe(onNext: { [weak self] image in
                guard let strongSelf = self else { return }
                strongSelf.showImage(image: image, in: strongSelf.avatarImageView)
            })
            .disposed(by: disposeBag)
        
        viewModel.background
            .filter { $0.0 != nil }
            .flatMap { [weak self] backgroundData -> Observable<UIImage?> in
                guard let strongSelf = self else { return Observable.empty() }
                return strongSelf.imageFetcher.fetchImage(from: backgroundData.0!, for: backgroundData.1)
            }
            .subscribe(onNext: { [weak self] image in
                guard let strongSelf = self else { return }
                strongSelf.showImage(image: image, in: strongSelf.backgroundImageView)
            })
            .disposed(by: disposeBag)

        viewModel.name
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.gender
            .bind(to: genderLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.city
            .bind(to: cityLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.email
            .bind(to: emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.description
            .bind(to: descriptionTextView.rx.text)
            .disposed(by: disposeBag)
        
        closeItem.rx.tap
            .bind(to: viewModel.close)
            .disposed(by: disposeBag)
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

