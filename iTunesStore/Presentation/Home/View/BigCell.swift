//
//  BigCell.swift
//  iTunesStore
//
//  Created by 김우성 on 7/30/25.
//

import Kingfisher
import UIKit

final class BigCell: UICollectionViewCell {
    private let titleLabel = UILabel().then {
        $0.text = "Album Name"
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 20, weight: .regular)
        $0.numberOfLines = 1
    }

    private let subtitleLabel = UILabel().then {
        $0.text = "Artist Name"
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 20, weight: .regular)
        $0.numberOfLines = 1
    }

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.backgroundColor = .systemGray6
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    private func configureUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(imageView)

        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageView.snp.width).multipliedBy(0.6)
            $0.bottom.equalToSuperview() // 핵심: 셀 높이 확정 가능하게!
        }
    }

    func configure(info: MediaInfo) {
        titleLabel.text = info.title
        subtitleLabel.text = info.subtitle
        imageView.kf.setImage(
            with: URL(string: info.imageUrl?.replacingOccurrences(of: "100x100bb.jpg", with: "600x600bb.jpg") ?? "")
        )
    }
}
