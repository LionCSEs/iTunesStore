//
//  Podcast.swift
//  iTunesStore
//
//  Created by 김우성 on 8/1/25.
//

struct Podcast: Codable, Hashable {
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let artworkUrl100: String?
}
