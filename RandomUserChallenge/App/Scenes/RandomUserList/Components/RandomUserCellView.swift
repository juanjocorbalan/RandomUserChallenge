//
//  RandomUserCellView.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit
import RxSwift

class RandomUserCellView: UICollectionViewCell {
    
    var disposeBag = DisposeBag()

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
        avatarImageView.image = nil
        backgroundImageView.image = nil
        nameLabel.text = nil
        cityLabel.text = nil
        disposeBag =  DisposeBag()
        setupUI()
    }
    
    func setup(with viewModel: RandomUserCellViewModel) {
        setupUI()
        
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
        
        viewModel.city
            .bind(to: cityLabel.rx.text)
            .disposed(by: disposeBag)
        
        removeButton.rx.tap.throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.removeSelected).disposed(by: disposeBag)

    }
    
    private func setupUI() {
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        cityLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2.0
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth = 3.0
        avatarImageView.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        containerView.layer.cornerRadius = 16.0
        containerView.layer.masksToBounds = true
        blurView.layer.cornerRadius = 16.0
        blurView.layer.masksToBounds = true
        containerView.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        containerView.layer.borderWidth = 1.0
        removeButton.tintColor = UIColor(named: "AccentColor")
    }
}

