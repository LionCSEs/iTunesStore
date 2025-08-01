//
//  ViewController.swift
//  iTunesStore
//
//  Created by estelle on 7/28/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class MusicViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: MusicViewModel
    private let searchController: UISearchController
    private let searchResultController: SearchViewController
    
    typealias DataSource = UICollectionViewDiffableDataSource<MusicSection, MusicItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MusicSection, MusicItem>
    
    private lazy var dataSource = createDataSource(collectionView: collectionView)
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: LayoutManager.shared.createCompositionalLayout(for: .music)).then {
        $0.backgroundColor = .systemBackground
    }
    
    init(viewModel: MusicViewModel, searchResultController: SearchViewController) {
        self.viewModel = viewModel
        self.searchController = UISearchController(searchResultsController: searchResultController)
        self.searchResultController = searchResultController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        searchController.searchBar.placeholder = "영화, 팟캐스트"
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.title = "Music"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - 바인딩
    
    private func bind() {
        // 초기 음악 요청
        viewModel.action.accept(.fetchMusic)
        
        // 음악 리스트 바인딩
        viewModel.state.map(\.musicItems)
            .drive { [weak self] musicItems in
                self?.updateSnapShot(musicItems)
            }
            .disposed(by: disposeBag)
        
        // 에러 메시지 바인딩
        viewModel.state.map(\.errorMessage)
            .drive { [weak self] errorMessage in
                self?.showAlert(message: errorMessage)
            }
            .disposed(by: disposeBag)
        
        // 검색 입력값 바인딩
        searchController.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.microseconds(500), scheduler: MainScheduler.instance)
            .bind(to: searchResultController.rx.searchText)
            .disposed(by: disposeBag)
            
        // 검색 라벨 바인딩
        searchResultController.labelTapGesture.rx.event
            .bind { [weak self] _ in
                self?.searchController.isActive = false
            }
            .disposed(by: disposeBag)
        
        // 키보드 내리기
        searchResultController.viewTapGesture.rx.event
            .bind { [weak self] _ in
                self?.searchController.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Diffable DataSource 생성
    
    private func createDataSource(collectionView: UICollectionView) -> DataSource {
        // 봄 섹션 셀 등록
        let springCellRegistration = UICollectionView.CellRegistration<SpringMusicCell, MusicItem> { cell, _, item in
            cell.configure(musicItem: item.music)
        }
        
        // 일반 셀 등록 (여름, 가을, 겨울)
        let listCellRegistration = UICollectionView.CellRegistration<ListMusicCell, MusicItem> { cell, _, item in
            cell.configure(musicItem: item.music)
        }
        
        // 섹션 헤더 등록
        let headerRegistration = UICollectionView.SupplementaryRegistration<MusicSectionHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, _, indexPath in
            let section = MusicSection(rawValue: indexPath.section)!
            headerView.configure(title: section.title, subTitle: section.subtitle)
        }
        
        // 셀 제공 로직
        let dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, item in
            let section = MusicSection(rawValue: indexPath.section)!
            switch section {
            case .spring:
                return collectionView.dequeueConfiguredReusableCell(
                    using: springCellRegistration, for: indexPath, item: item
                )
            default:
                return collectionView.dequeueConfiguredReusableCell(
                    using: listCellRegistration, for: indexPath, item: item
                )
            }
        }
        
        // 헤더 제공 로직
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
        }
        
        return dataSource
    }
    
    // MARK: - Snapshot 업데이트
    
    private func updateSnapShot(_ musicItems: [[Media]]) {
        var snapshot = Snapshot()
        snapshot.appendSections(MusicSection.allCases)
        zip(musicItems, MusicSection.allCases).forEach { musicItems, section in
            let items = musicItems.map { MusicItem(music: $0, section: section)}
            snapshot.appendItems(items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

