//
//  Podcast.swift
//  iTunesStore
//
//  Created by Milou on 7/29/25.
//

import Foundation

struct Podcast {
  let id: Int // trackId
  let mediaType: MediaType = .podcast
  let artistName: String
  let collectionName: String
  let trackName: String
  let artworkUrl: String // artworkUrl100
  let genre: String? // primaryGenreName
  
  let genres: [String]
  let releaseDate: Date?
}
