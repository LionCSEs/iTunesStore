//
//  SearchResultHeaderView.swift
//  iTunesStore
//
//  Created by 김우성 on 8/1/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class SearchResultHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SearchResultHeaderView"

    let titleButton = UIButton().then {
        $0.setTitle("검색어", for: .normal)
        $0.setTitleColor(.label, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 36, weight: .bold)
        $0.contentHorizontalAlignment = .left
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleButton)

        titleButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setTitle(_ title: String) {
        print(">>> setTitle called with: \(title)") // 디버그
        titleButton.setTitle(title, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
