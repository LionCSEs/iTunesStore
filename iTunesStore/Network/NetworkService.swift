//
//  NetworkService.swift
//  iTunesStore
//
//  Created by 김우성 on 7/29/25.
//

/// https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html

import Alamofire
import Foundation
import RxSwift

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchMedia<T: Decodable>(term: String, mediaType: String, limit: Int) -> Observable<[T]> {
        guard let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return Observable.just([])
        }
        
        let url = "https://itunes.apple.com/search?term=\(encodedTerm)&media=\(mediaType)&country=KR&limit=\(limit)"
        
        return Observable.create { observer in
            AF.request(url)
                .validate()
                .responseDecodable(of: SearchResponse<T>.self) { response in
                    switch response.result {
                    case .success(let result):
                        print("응답 성공: \(result.results.count)개 항목")
                        observer.onNext(result.results)
                        observer.onCompleted()
                    case .failure(let error):
                        print("응답 실패: \(error)")
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
}
