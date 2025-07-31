//
//  MovieDTO.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//

import Foundation

struct MovieResponseDTO: Decodable {
  let resultCount: Int
  let results: [MovieDTO]
}

struct MovieDTO: Decodable {
  let trackId: Int
  let artistName: String
  let collectionName: String
  let trackName: String
  let artworkUrl100: String
  let artworkUrl600: String?
  let primaryGenreName: String?
  let contentAdvisoryRating: String?
  let releaseDate: Date?
  
  var artworkUrl: String {
      return artworkUrl600 ?? artworkUrl100
    }
  
  func toEntity() -> Movie {
    return Movie(
      id: trackId,
      artistName: artistName,
      collectionName: collectionName,
      trackName: trackName,
      artworkUrl: artworkUrl,
      genre: primaryGenreName,
      contentRating: contentAdvisoryRating,
      releaseDate: releaseDate
    )
  }
}
