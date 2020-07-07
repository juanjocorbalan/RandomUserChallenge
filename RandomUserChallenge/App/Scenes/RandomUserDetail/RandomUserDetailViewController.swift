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
    
    var viewModel: RandomUserDetailViewModel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
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
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        genderLabel.font = UIFont.preferredFont(forTextStyle: .body)
        cityLabel.font = UIFont.preferredFont(forTextStyle: .body)
        emailLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionTextView.font = UIFont.preferredFont(forTextStyle: .body)
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2.0
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth = 3.0
        avatarImageView.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        descriptionTextView.textContainerInset = .zero
        blurView1.layer.cornerRadius = 16.0
        blurView1.layer.masksToBounds = true
        blurView2.layer.cornerRadius = 16.0
        blurView2.layer.masksToBounds = true
        backgroundImageView.alpha = 0.5
    }
    
    private func setupBindings() {
        
        viewModel.avatar
            .filter { $0 != nil }
            .subscribe(onNext: { url in
                self.avatarImageView.with(url: url!)
            })
            .disposed(by: disposeBag)
        
        viewModel.background
            .filter { $0 != nil }
            .subscribe(onNext: { url in
                self.backgroundImageView.with(url: url!)
            })
            .disposed(by: disposeBag)
        
        viewModel.name
            .bind(to: nameLabel.rx.text)
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
    }
}

