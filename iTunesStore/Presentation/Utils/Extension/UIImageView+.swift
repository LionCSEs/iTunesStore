//
//  UIImageView+.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage,
                .scaleFactor(UIScreen.main.scale)
            ])
    }
}
