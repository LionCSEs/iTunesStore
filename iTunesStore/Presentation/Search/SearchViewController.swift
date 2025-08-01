//
//  SearchViewController.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: SearchViewModel
    
    typealias DataSource = UICollectionViewDiffableDataSource<SearchSection, SearchItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchItem>
    
    private lazy var dataSource = createDataSource(collectionView: collectionView)
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: LayoutManager.shared.createCompositionalLayout(for: .search)).then {
        $0.backgroundColor = .systemBackground
    }
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.action.accept(.fetchSearchData)
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        viewModel.state.map(\.searchItems)
            .asDriver(onErrorJustReturn: [])
            .drive { [weak self] items in
                self?.updateSnapShot(items)
            }
            .disposed(by: disposeBag)
        
        viewModel.state.map(\.errorMessage)
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] errorMessage in
                self?.showAlert(message: errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    private func createDataSource(collectionView: UICollectionView) -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<SearchCell, SearchItem> {
            cell, _, searchItem in
            cell.configure(musicItem: searchItem.item)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<SearchSectionHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, _, indexPath in
            let section = SearchSection(rawValue: indexPath.section)!
            headerView.configure(title: section.title)
        }
        
        let dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, searchItem in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: searchItem
            )
        }
        
        dataSource.supplementaryViewProvider = {
            collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        return dataSource
    }
    
    func updateSnapShot(_ items: [[Media]]) {
        var snapshot = Snapshot()
        snapshot.appendSections(SearchSection.allCases)
        
        zip(items, SearchSection.allCases).forEach { items, section in
            let items = items.map { SearchItem(item: $0, section: section) }
            snapshot.appendItems(items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
