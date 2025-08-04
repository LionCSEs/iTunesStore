//
//  SearchResponse.swift
//  iTunesStore
//
//  Created by 김우성 on 7/29/25.
//

struct SearchResponse<T: Decodable>: Decodable {
    let resultCount: Int
    let results: [T]
}
