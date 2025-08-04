//
//  MusicSectionHeaderView.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import UIKit
import SnapKit

class MusicSectionHeaderView: UICollectionReusableView {
    
    private let titleLabel = TitleLabel(fontSize: 20)
    private let subTitleLabel = SubTitleLabel(fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [titleLabel, subTitleLabel].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
