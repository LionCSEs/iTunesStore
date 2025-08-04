//
//  MusicSection.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import Foundation

// 계절별 음악 섹션 정의
enum MusicSection: Int, CaseIterable {
    case spring
    case summer
    case autumn
    case winter
    
    var title: String {
        switch self {
        case .spring:
            return "봄"
        case .summer:
            return "여름"
        case .autumn:
            return "가을"
        case .winter:
            return "겨울"
        }
    }
    
    var subtitle: String {
        return "\(title)에 어울리는 음악"
    }
}
