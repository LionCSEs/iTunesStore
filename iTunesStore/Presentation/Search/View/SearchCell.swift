//
//  SearchCell.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import UIKit
import Then
import SnapKit

class SearchCell: UICollectionViewCell {
    
    private let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let gradientView = GradientView()
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .label
    }
    
    private let artistLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .secondaryLabel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 8
        layer.masksToBounds = false
        
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        
        [backgroundImageView, gradientView, titleLabel, artistLabel].forEach { contentView.addSubview($0) }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints {
            $0.edges.equalTo(backgroundImageView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        artistLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.image = nil
        titleLabel.text = nil
        artistLabel.text = nil
    }
    
    func configure(searchItem: Media) {
        titleLabel.text = searchItem.trackName
        artistLabel.text = searchItem.artistName
        
        if let imageURL = URL(string: searchItem.artworkUrl600) {
            backgroundImageView.loadImage(from: imageURL)
        } else {
            //backgroundImageView.image = UIImage(named: "musicPlaceholder")
        }
    }
}
