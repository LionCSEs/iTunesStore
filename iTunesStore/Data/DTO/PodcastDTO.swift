//
//  PodcastDTO.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//

import Foundation

struct PodcastResponseDTO: Decodable {
  let resultCount: Int
  let results: [PodcastDTO]
}

struct PodcastDTO: Decodable {
  let trackId: Int
  let artistName: String
  let collectionName: String
  let trackName: String
  let artworkUrl100: String
  let artworkUrl600: String?
  let primaryGenreName: String?
  let genres: [String]
  let releaseDate: Date?
  
  var artworkUrl: String {
      return artworkUrl600 ?? artworkUrl100
    }
  
  func toEntity() -> Podcast {
    return Podcast(
      id: trackId,
      artistName: artistName,
      collectionName: collectionName,
      trackName: trackName,
      artworkUrl: artworkUrl,
      genre: primaryGenreName,
      genres: genres,
      releaseDate: releaseDate
    )
  }
}
