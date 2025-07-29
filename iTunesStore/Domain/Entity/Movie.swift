//
//  Movie.swift
//  iTunesStore
//
//  Created by Milou on 7/29/25.
//

import Foundation

struct Movie {
  let id: Int // trackId
  let mediaType: MediaType = .movie
  let artistName: String
  let collectionName: String
  let trackName: String
  let artworkUrl: String // artworkUrl100
  let genre: String? // primaryGenreName
  
  let contentRating: String? // contentAdvisoryRating
  let releaseDate: Date?
}
