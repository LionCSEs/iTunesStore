//
//  LayoutManager.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import UIKit

enum LayoutType {
    case music
    case search
}

// 컴포지셔널 레이아웃을 관리하는 싱글톤 클래스
class LayoutManager {
    static let shared = LayoutManager()
    
    private init() {}
    
    func createCompositionalLayout(for type: LayoutType) -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 40
        
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            // 음악 레이아웃 처리
            if type == .music {
                guard let sectionType = MusicSection(rawValue: sectionIndex) else { return nil }
                
                switch sectionType {
                case .spring:
                    return self.createSpringMusicLayout()
                case .summer, .autumn, .winter:
                    return self.createListMusicLayout()
                }
            // 검색 결과 레이아웃 처리
            } else if type == .search {
                return self.createSearchResultLayout()
            } else {
                return self.createSearchResultLayout()
            }
        }, configuration: configuration)
    }
    
    // 봄 섹션 레이아웃
    private func createSpringMusicLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = UIScreen.main.bounds.width * 0.06
        section.boundarySupplementaryItems = [createSectionHeader()]
        
        return section
    }
    
    // 봄 외의 계절 섹션 레이아웃
    private func createListMusicLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0/3.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                               heightDimension: .absolute(260))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = UIScreen.main.bounds.width * 0.06
        section.boundarySupplementaryItems = [createSectionHeader()]
        
        return section
    }
    
    // 검색 결과 섹션 레이아웃
    private func createSearchResultLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0/2.6),
            heightDimension: .absolute(230)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        //group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = UIScreen.main.bounds.width * 0.06
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.boundarySupplementaryItems = [createSectionHeader()]
        
        return section
    }
    
    // 공통 섹션 헤더 생성
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}
