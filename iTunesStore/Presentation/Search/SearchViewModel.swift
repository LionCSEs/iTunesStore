//
//  SearchViewModel.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import RxSwift
import RxRelay
import RxCocoa

class SearchViewModel {
    // UI에 상태 전달 BehaviorRelay
    private let stateRelay = BehaviorRelay(value: State(searchItems: [], errorMessage: ""))
    
    // 유저 액션 입력 받는 PublishRelay
    let action = PublishRelay<Action>()

    let disposeBag = DisposeBag()

    // 외부에서 상태 구독
    var state: Driver<State> {
        stateRelay.asDriver(onErrorJustReturn: State(searchItems: [], errorMessage: ""))
    }

    init() {
        action
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .fetchSearchData(let term):
                    self?.fetchMovieAndPodcast(term)
                }
            })
            .disposed(by: disposeBag)
    }

    // 각 데이터 리스트 받음
    private func fetchMovieAndPodcast(_ term: String) {
        let movie: Single<[Media]> = NetworkManager.shared.fetch(
            apiEndPoint: .search(query: SearchSection.movie.query, term: term)
        )
        let podcast: Single<[Media]> = NetworkManager.shared.fetch(
            apiEndPoint: .search(query: SearchSection.podcast.query, term: term)
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
        case fetchSearchData(term: String)
    }

    struct State {
        var searchItems: [[Media]]
        var errorMessage: String
    }
}
