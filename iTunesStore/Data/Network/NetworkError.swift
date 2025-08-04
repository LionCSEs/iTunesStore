//
//  NetworkError.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import Foundation

// 네트워크 오류 정의
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case dataFetchFailed
    case decodingFailed
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "URL이 유효하지 않습니다."
        case .dataFetchFailed:
            return "데이터 호출에 실패했습니다."
        case .decodingFailed:
            return "디코딩에 실패했습니다."
        }
    }
}
