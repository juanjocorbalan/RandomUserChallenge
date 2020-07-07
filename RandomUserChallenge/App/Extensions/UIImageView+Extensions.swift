//
//  UIImageView+Extensions.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 07/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func with(url: URL?) {
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }).resume()
    }
}
