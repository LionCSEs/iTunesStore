//
//  TitleLabel.swift
//  iTunesStore
//
//  Created by estelle on 8/3/25.
//

import UIKit

class TitleLabel: UILabel {
    init(fontSize: CGFloat) {
        super.init(frame: .zero)
        self.font = .systemFont(ofSize: fontSize, weight: .bold)
        self.textColor = .label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
