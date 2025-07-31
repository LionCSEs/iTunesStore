//
//  NetworkServiceImp.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//

import Foundation
import RxSwift
import RxCocoa

class NetworkServiceImp: NetworkService {
  private let urlSession: URLSession
  
  init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }
  
  func fetch<T>(endPoint: any APIEndpoint) -> Single<T> where T: Decodable {
    guard let url = endPoint.url else {
      return .error(NetworkError.invalidURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    return URLSession.shared.rx.data(request: request)
      .asSingle()
      .map { data in
        do {
          let decodedData = try JSONDecoder().decode(T.self, from: data)
          return decodedData
        } catch {
          print("🥵 Decoding Error: \(error)")
          throw NetworkError.decodingError(description: error.localizedDescription)
        }
      }
      .catch { error in
        if let urlError = error as? URLError {
          throw NetworkError.invalidStatusCode(urlError.errorCode)
        }
        throw NetworkError.unknown
      }
  }
}
