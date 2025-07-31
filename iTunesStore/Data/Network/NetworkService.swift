//
//  NetworkService.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//
import RxSwift

protocol NetworkService {
  func fetch<T: Decodable>(endPoint: APIEndpoint) -> Single<T>
}
