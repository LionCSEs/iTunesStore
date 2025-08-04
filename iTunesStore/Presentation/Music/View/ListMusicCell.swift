//
//  ListMusicCell.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import UIKit
import SnapKit
import Then

class ListMusicCell: UICollectionViewCell {
    
    // 그림자와 둥근 모서리를 주기 위한 컨테이너 뷰
    private let shadowContainerView = UIView().then {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 4
        $0.layer.masksToBounds = false
        $0.layer.cornerRadius = 15
    }
    
    // 앨범 이미지 뷰
    private let albumImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    // 곡 제목, 아티스트 이름
    private let titleLabel = TitleLabel(fontSize: 16)
    private let artistLabel = SubTitleLabel(fontSize: 14)
    
    // 제목과 아티스트 스택뷰
    private lazy var labelStackView = UIStackView(arrangedSubviews: [titleLabel, artistLabel]).then {
        $0.axis = .vertical
        $0.spacing = 6
    }
    
    // 셀 하단 구분선
    private let separatorView = UIView().then {
        $0.backgroundColor = .separator
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        shadowContainerView.addSubview(albumImageView)
        [shadowContainerView, labelStackView, separatorView].forEach { contentView.addSubview($0) }
        
        shadowContainerView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(60)
        }
        
        albumImageView.snp.makeConstraints {
            $0.edges.equalTo(shadowContainerView)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(albumImageView.snp.trailing).offset(10)
            $0.trailing.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
        titleLabel.text = nil
        artistLabel.text = nil
    }
    
    func configure(musicItem: Media) {
        titleLabel.text = musicItem.trackName
        artistLabel.text = musicItem.artistName
        
        if let imageURL = URL(string: musicItem.artworkUrl600) {
            albumImageView.loadImage(from: imageURL)
        } else {
            albumImageView.contentMode = .center
            albumImageView.image = UIImage(
                systemName: "photo",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)
            )?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        }
    }
}
