//
//  NetworkError.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//

import Foundation

enum NetworkError: Error {
  case invalidURL
  case invalidStatusCode(Int)
  case decodingError(description: String)
  case unknown
}
