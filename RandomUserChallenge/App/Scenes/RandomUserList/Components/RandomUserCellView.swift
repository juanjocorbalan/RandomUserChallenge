//
//  RandomUserCellView.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit

class RandomUserCellView: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var gackgroundImage: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup(with viewModel: RandomUserCellViewModel) {
        self.textLabel?.text = viewModel.name
        self.detailTextLabel?.text = viewModel.city
    }
}

