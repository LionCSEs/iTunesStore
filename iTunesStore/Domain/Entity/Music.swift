//
//  Music.swift
//  iTunesStore
//
//  Created by Milou on 7/29/25.
//

import Foundation

struct Music {
  let id: Int // trackId
  let mediaType: MediaType = .music
  let artistName: String
  let collectionName: String
  let trackName: String
  let artworkUrl: String // artworkUrl100
  let genre: String? // primaryGenreName
}
