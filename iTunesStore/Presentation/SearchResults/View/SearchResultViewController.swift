//
//  SearchResultViewController.swift
//  iTunesStore
//
//  Created by 김우성 on 8/1/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SearchResultViewController: UIViewController {
    private enum Section {
        case main
    }

    private let viewModel = SearchResultViewModel()
    private let disposeBag = DisposeBag()

    private var dataSource: UICollectionViewDiffableDataSource<Section, MediaInfo>!
    private var latestQuery: String = ""

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["모두", "영화", "팟캐스트"])
        control.selectedSegmentIndex = 0
        return control
    }()

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: SearchResultViewController.createLayout()
    ).then {
        $0.backgroundColor = .systemBackground
        $0.register(SearchResultCell.self, forCellWithReuseIdentifier: "SearchResultCell")
        $0.register(
            SearchResultHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SearchResultHeaderView.reuseIdentifier
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
        makeDataSource()
        bind()
    }

    private func layout() {
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)

        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func makeDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MediaInfo>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "SearchResultCell",
                for: indexPath
            ) as! SearchResultCell
            
            let showType = self?.segmentedControl.selectedSegmentIndex == 0
            cell.configure(with: model, showMediaType: showType)
            return cell
        }

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }

            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SearchResultHeaderView.reuseIdentifier,
                for: indexPath
            ) as! SearchResultHeaderView

            header.setTitle(self?.latestQuery ?? "")

            header.titleButton.rx.tap
                .bind { [weak self] in
                    guard let self = self else { return }
                    self.dismiss(animated: true)
                }
                .disposed(by: self!.disposeBag)

            return header
        }
    }

    private func bind() {
        // 탭 선택 이벤트 처리
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                let tab: MediaTab
                switch index {
                case 1: tab = .movie
                case 2: tab = .podcast
                default: tab = .all
                }
                self.viewModel.actionRelay.accept(.search(query: self.latestQuery, selectedTab: tab))
            })
            .disposed(by: disposeBag)

        // 상태 바인딩
        viewModel.stateDriver
            .drive(onNext: { [weak self] state in
                self?.latestQuery = state.queryText
                var snapshot = NSDiffableDataSourceSnapshot<Section, MediaInfo>()
                snapshot.appendSections([.main])
                snapshot.appendItems(state.mediaItems)
                snapshot.reloadSections([.main]) // 기존 apply 전에 헤더 포함 섹션 강제 reload (서치바에 입력하는 내용 바로 반영용)
                
                self?.dataSource.apply(snapshot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
    }

    func performSearch(query: String) {
        latestQuery = query
        let currentTab: MediaTab
        switch segmentedControl.selectedSegmentIndex {
        case 1: currentTab = .movie
        case 2: currentTab = .podcast
        default: currentTab = .all
        }
        viewModel.actionRelay.accept(.search(query: query, selectedTab: currentTab))
    }

    static func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(350)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(350)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        return UICollectionViewCompositionalLayout(section: section)
    }
}
