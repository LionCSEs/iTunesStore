//
//  File.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import Foundation

// 검색 섹션 정의
enum SearchSection: Int, CaseIterable {
    case movie
    case podcast
    
    var query: String {
        switch self {
        case .movie:
            return "movie"
        case .podcast:
            return "podcast"
        }
    }
    
    var title: String {
        switch self {
        case .movie:
            return "영화"
        case .podcast:
            return "팟캐스트"
        }
    }
}
