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
    
    var searchText = "" {
        didSet {
            searchTextRelay.accept(searchText)
        }
    }
    private let searchTextRelay = PublishRelay<String>()
    
    typealias DataSource = UICollectionViewDiffableDataSource<SearchSection, SearchItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchItem>
    
    private lazy var dataSource = createDataSource(collectionView: collectionView)
    
    let labelTapGesture = UITapGestureRecognizer()
    let viewTapGesture = UITapGestureRecognizer()
    
    private let searchTextLabel = TitleLabel(fontSize: 26)
    
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
        bind()
        viewTapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(viewTapGesture)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        searchTextLabel.isUserInteractionEnabled = true
        searchTextLabel.addGestureRecognizer(labelTapGesture)
        [searchTextLabel, collectionView].forEach { view.addSubview($0) }
        
        searchTextLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchTextLabel.snp.bottom).offset(6)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - 바인딩
    
    private func bind() {
        searchTextRelay.bind(to: searchTextLabel.rx.text).disposed(by: disposeBag)
        
        // 검색어 바인딩
        searchTextRelay
            .map {.fetchSearchData(term: $0)}
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        // 검색 결과 바인딩
        viewModel.state.map(\.searchItems)
            .drive { [weak self] items in
                self?.updateSnapShot(items)
            }
            .disposed(by: disposeBag)
        
        // 에러 메시지 바인딩
        viewModel.state.map(\.errorMessage)
            .drive { [weak self] errorMessage in
                self?.showAlert(message: errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Diffable DataSource 생성
    
    private func createDataSource(collectionView: UICollectionView) -> DataSource {
        // 셀 등록
        let cellRegistration = UICollectionView.CellRegistration<SpringMusicAndSearchCell, SearchItem> {
            cell, _, searchItem in
            cell.configure(item: searchItem.item)
        }
        
        // 섹션 헤더 등록
        let headerRegistration = UICollectionView.SupplementaryRegistration<SearchSectionHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, _, indexPath in
            let section = SearchSection(rawValue: indexPath.section)!
            headerView.configure(title: section.title)
        }
        
        // 셀 제공 로직
        let dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, searchItem in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: searchItem
            )
        }
        
        // 헤더 제공 로직
        dataSource.supplementaryViewProvider = {
            collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        return dataSource
    }
    
    // MARK: - Snapshot 업데이트
    
    func updateSnapShot(_ items: [[Media]]) {
        var snapshot = Snapshot()
        snapshot.appendSections(SearchSection.allCases)
        
        zip(items, SearchSection.allCases).forEach { items, section in
            let emptyItem = SearchItem(item: Media(trackId: 0, trackName: "검색 결과 없음", artistName: "", artworkUrl100: "", releaseDate: "", primaryGenreName: ""), section: section)
            let items = items.map { SearchItem(item: $0, section: section) }
            snapshot.appendItems(items.isEmpty ? [emptyItem] : items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
