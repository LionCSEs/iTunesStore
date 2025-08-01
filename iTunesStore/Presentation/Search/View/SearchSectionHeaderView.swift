//
//  SearchSectionHeaderView.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import UIKit
import Then
import SnapKit

class SearchSectionHeaderView: UICollectionReusableView {
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [titleLabel].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
