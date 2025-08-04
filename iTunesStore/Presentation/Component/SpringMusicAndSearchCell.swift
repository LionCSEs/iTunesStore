//
//  SpringMusicCell.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import UIKit
import Then
import SnapKit

class SpringMusicAndSearchCell: UICollectionViewCell {
    
    // 배경 이미지
    private let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray6
        $0.clipsToBounds = true
    }
    
    // 그라데이션용 오버레이 뷰, 곡 제목, 아티스트 이름
    private let gradientView = GradientView()
    private let titleLabel = TitleLabel(fontSize: 16)
    private let artistLabel = SubTitleLabel(fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 셀 그림자 설정
        layer.shadowColor = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }.cgColor
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
    
    func configure(item: Media) {
        titleLabel.text = item.trackName
        artistLabel.text = item.artistName
        
        if let imageURL = URL(string: item.artworkUrl600) {
            backgroundImageView.loadImage(from: imageURL)
        } else {
            backgroundImageView.contentMode = .center
            backgroundImageView.image = UIImage(
                systemName: "photo",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)
            )?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.shadowColor = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }.cgColor
    }
}
