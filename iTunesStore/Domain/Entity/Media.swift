//
//  Media.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import Foundation

struct MediaResponse<T: Decodable>: Decodable {
    let results: [T]
}

struct Media: Decodable {
    let trackId: Int
    let trackName: String
    let artistName: String
    let artworkUrl100: String
    let releaseDate: String
    let primaryGenreName: String
    
    var artworkUrl600: String {
        artworkUrl100.replacingOccurrences(of: "100x100", with: "600x600")
    }
}
