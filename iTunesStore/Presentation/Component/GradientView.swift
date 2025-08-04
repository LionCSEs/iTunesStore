//
//  GradientView.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import UIKit
import Then

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer().then {
        $0.colors = [UIColor.systemBackground.withAlphaComponent(0.0).cgColor, UIColor.systemBackground.withAlphaComponent(0.9).cgColor]
        $0.startPoint = .init(x: 0.5, y: 0)
        $0.endPoint = .init(x: 0.5, y: 1)
        $0.locations = [0.7, 0.86]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        gradientLayer.colors = [UIColor.systemBackground.withAlphaComponent(0.0).cgColor, UIColor.systemBackground.withAlphaComponent(0.9).cgColor]
    }
}
