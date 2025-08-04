//
//  HeaderView.swift
//  iTunesStore
//
//  Created by 김우성 on 8/1/25.
//

import SnapKit
import Then
import UIKit

final class HeaderView: UICollectionReusableView {
    static let reuseIdentifier = "HeaderView"
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
