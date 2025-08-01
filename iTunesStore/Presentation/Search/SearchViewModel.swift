//
//  SearchViewModel.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import RxSwift
import RxRelay

class SearchViewModel {
    private let stateRelay = BehaviorRelay(value: State(searchItems: [], errorMessage: ""))
    
    let action = PublishRelay<Action>()

    let disposeBag = DisposeBag()

    var state: Observable<State> {
        stateRelay.asObservable()
    }

    init() {
        action
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .fetchSearchData:
                    self?.fetchMovieAndPodcast()
                }
            })
            .disposed(by: disposeBag)
    }

    private func fetchMovieAndPodcast() {
        let movie: Single<[Media]> = NetworkManager.shared.fetch(
            apiEndPoint: .search(query: SearchSection.movie.query, term: "Marvel")
        )
        let podcast: Single<[Media]> = NetworkManager.shared.fetch(
            apiEndPoint: .search(query: SearchSection.podcast.query, term: "Marvel")
        )

        Single.zip(movie, podcast)
            .subscribe(onSuccess: { [weak self] movie, podcast in
                let searchItems = [movie, podcast]
                self?.stateRelay.accept(State(searchItems: searchItems, errorMessage: ""))
            }, onFailure: { [weak self] error in
                if let networkError = error as? NetworkError {
                    self?.stateRelay.accept(
                        State(searchItems: [], errorMessage: networkError.errorDescription)
                    )
                } else {
                    self?.stateRelay.accept(State(searchItems: [], errorMessage:  "알 수 없는 오류가 발생했습니다."))
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SearchViewModel {
    enum Action {
        case fetchSearchData
    }

    struct State {
        var searchItems: [[Media]]
        var errorMessage: String
    }
}
