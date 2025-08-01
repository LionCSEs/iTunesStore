//
//  APIEndPoint.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import Foundation

enum APIEndPoint {
    case music(term: MusicSection)              // 계절별 음악 검색
    case search(query: String, term: String)    // 사용자 검색 쿼리
    
    // URLRequest 생성
    var urlRequest: URLRequest? {
        let baseURL = "https://itunes.apple.com/search"
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        
        switch self {
        case .music(let sesson):
            urlComponents.queryItems = [
                URLQueryItem(name: "country", value: "kr"),
                URLQueryItem(name: "media", value: "music"),
                URLQueryItem(name: "entity", value: "song"),
                URLQueryItem(name: "term", value: sesson.title)
            ]
        case .search(let query, let term):
            urlComponents.queryItems = [
                URLQueryItem(name: "country", value: "kr"),
                URLQueryItem(name: "media", value: query),
                URLQueryItem(name: "entity", value: query),
                URLQueryItem(name: "term", value: term)
            ]
        }
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
