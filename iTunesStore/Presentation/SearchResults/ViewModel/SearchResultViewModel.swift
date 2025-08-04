//
//  SearchResultViewModel.swift
//  iTunesStore
//
//  Created by 김우성 on 8/1/25.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

// MARK: - 탭 구분용 열거형
enum MediaTab {
    case all       // 전체 결과 (영화 + 팟캐스트)
    case movie     // 영화만
    case podcast   // 팟캐스트만
}

// MARK: - 검색 결과 뷰모델
final class SearchResultViewModel {

    // MARK: - 상태 정의 (뷰에서 관찰)
    struct State {
        var queryText: String = ""
        var mediaItems: [MediaInfo] = []
    }

    // MARK: - 액션 정의 (뷰에서 전달)
    enum Action {
        case search(query: String, selectedTab: MediaTab)
    }

    // MARK: - Rx 구성 요소
    private let disposeBag = DisposeBag()
    let actionRelay = PublishRelay<Action>() // 뷰에서 발생한 액션이 전달되는 통로
    let stateRelay = BehaviorRelay<State>(value: State()) // 상태를 저장하고 전달

    // 뷰에 전달할 상태 스트림 (Driver는 UI 바인딩에 적합한 RxCocoa 타입)
    var stateDriver: Driver<State> {
        stateRelay.asDriver()
    }

    // MARK: - 초기 바인딩
    init() {
        actionRelay
            .flatMapLatest { [weak self] action -> Observable<State> in
                guard let self = self else { return .empty() }

                switch action {
                case let .search(query, tab):

                    // 각 탭별로 Observable<[MediaInfo]> 반환
                    let movieObservable = NetworkService.shared
                        .fetchMedia(term: query, mediaType: "movie", limit: 10)
                        .map { (movies: [Movie]) in movies.map(MediaInfo.from) }
                        .catchAndReturn([])

                    let podcastObservable = NetworkService.shared
                        .fetchMedia(term: query, mediaType: "podcast", limit: 10)
                        .map { (podcasts: [Podcast]) in podcasts.map(MediaInfo.from) }
                        .catchAndReturn([])

                    // 두 요청을 zip으로 묶어 하나의 State로 반환
                    return Observable.zip(movieObservable, podcastObservable)
                        .map { movieItems, podcastItems in
                            let combined: [MediaInfo]
                            switch tab {
                            case .all:
                                combined = podcastItems + movieItems
                            case .movie:
                                combined = movieItems
                            case .podcast:
                                combined = podcastItems
                            }

                            return State(
                                queryText: query,
                                mediaItems: combined
                            )
                        }
                }
            }
            .bind(to: stateRelay)
            .disposed(by: disposeBag)
    }
}
