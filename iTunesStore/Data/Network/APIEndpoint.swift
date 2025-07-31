//
//  APIEndpoint.swift
//  iTunesStore
//
//  Created by Milou on 7/29/25.
//

import Foundation

protocol APIEndpoint {
  var baseURL: String { get }
  var path: String { get }
  var parameters: [String: String] { get }
}

extension APIEndpoint {
  var url: URL? {
    var components = URLComponents(string: baseURL + path)
    
    if !parameters.isEmpty {
      components?.queryItems = parameters.map {
        URLQueryItem(name: $0.key, value: $0.value)
      }
    }
    return components?.url
  }
}

enum iTunesEndpoint: APIEndpoint {
  case seasonMusic(season: SeasonType)
  case searchMovies(term: String)
  case searchPodcasts(term: String)
  
  var baseURL: String {
    return "https://itunes.apple.com"
  }
  
  var path: String {
    return "/search"
  }
  
  var parameters: [String: String] {
    var params = ["lang": "ko_KR"]
    
    switch self {
    case .seasonMusic(let season):
      params["term"] = season.rawValue
      params["media"] = MediaType.music.rawValue
      
    case .searchMovies(term: let term):
      params["term"] = term
      params["media"] = MediaType.movie.rawValue
      
    case .searchPodcasts(term: let term):
      params["term"] = term
      params["media"] = MediaType.podcast.rawValue
    }
    
    return params
  }
}
