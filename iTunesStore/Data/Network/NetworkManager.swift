//
//  NetworkManager.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import Foundation
import RxSwift

// 네트워크 요청 처리하는 싱글톤 매니저
class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    // iTunes API 요청 (제네릭 디코딩, RxSwift 기반 비동기 처리)
    func fetch<T: Decodable>(apiEndPoint: APIEndPoint) -> Single<[T]> {
        guard let requestUrl = apiEndPoint.urlRequest else {
            return .error(NetworkError.invalidURL)
        }
        
        return Single.create { observer in
            let task = URLSession.shared.dataTask(with: requestUrl) { data, response, error in
                if let _ = error {
                    observer(.failure(NetworkError.dataFetchFailed))
                    return
                }
                
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    observer(.failure(NetworkError.dataFetchFailed))
                    return
                }

                do {
                    let decodedData = try JSONDecoder().decode(MediaResponse<T>.self, from: data)
                    observer(.success(decodedData.results))
                } catch {
                    observer(.failure(NetworkError.decodingFailed))
                }
            }
            
            task.resume()
            
            return Disposables.create()
        }
    }
}
