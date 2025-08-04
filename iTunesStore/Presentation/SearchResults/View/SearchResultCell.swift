//
//  SearchResultCell.swift
//  iTunesStore
//
//  Created by 김우성 on 8/1/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class SearchResultCell: UICollectionViewCell {
    private let subtitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 1
    }

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .label
        $0.numberOfLines = 2
    }

    private let artworkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 0
        $0.backgroundColor = .systemGray6
    }

    private let mediaTypeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .white
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        $0.textAlignment = .center
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.isHidden = true // 🔑 초기값은 hidden
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        styleCell()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        artworkImageView.image = nil
        mediaTypeLabel.isHidden = true
    }

    private func configureUI() {
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artworkImageView)
        contentView.addSubview(mediaTypeLabel)

        subtitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        artworkImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(artworkImageView.snp.width)
        }

        mediaTypeLabel.snp.remakeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(20)
            $0.width.greaterThanOrEqualTo(50)
        }
    }

    private func styleCell() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = generateRandomPastelColor()
    }

    func configure(with model: MediaInfo, showMediaType: Bool) {
        subtitleLabel.text = model.subtitle
        titleLabel.text = model.title
        
        if let urlString = model.imageUrl, let url = URL(string: urlString) {
            artworkImageView.kf.setImage(with: url)
        } else {
            artworkImageView.image = UIImage(systemName: "photo")
        }
        
        mediaTypeLabel.isHidden = !showMediaType
        mediaTypeLabel.text = model.mediaType
    }

    private func generateRandomPastelColor() -> UIColor {
        let hue = CGFloat.random(in: 0...1)
        let saturation = CGFloat.random(in: 0.2...0.4)
        let brightness = CGFloat.random(in: 0.85...0.95)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
