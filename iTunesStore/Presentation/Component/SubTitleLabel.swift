//
//  SubTitleLabel.swift
//  iTunesStore
//
//  Created by estelle on 8/3/25.
//

import UIKit

class SubTitleLabel: UILabel {
    init(fontSize: CGFloat) {
        super.init(frame: .zero)
        self.font = .systemFont(ofSize: fontSize, weight: .bold)
        self.textColor = .secondaryLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
