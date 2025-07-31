//
//  MusicDTO.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//

import Foundation

struct MusicResponseDTO: Decodable {
  let resultCount: Int
  let results: [MusicDTO]
}

struct MusicDTO: Decodable {
  let trackId: Int
  let artistName: String
  let collectionName: String?
  let trackName: String
  let artworkUrl100: String
  let artworkUrl600: String?
  let primaryGenreName: String?
  
  var artworkUrl: String {
      return artworkUrl600 ?? artworkUrl100
    }
  
  func toEntity() -> Music {
    return Music(
      id: trackId,
      artistName: artistName,
      albumName: collectionName ?? "Unknown Album",
      trackName: trackName,
      artworkUrl: artworkUrl,
      genre: primaryGenreName
    )
  }
}
