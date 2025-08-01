//
//  MusicViewModel.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import RxSwift
import RxRelay

class MusicViewModel {
    // UI에 상태 전달 BehaviorRelay
    private let stateRelay = BehaviorRelay(value: State(musicItems: [], errorMessage: ""))
    
    // 유저 액션 입력 받는 PublishRelay
    let action = PublishRelay<Action>()
    
    private let disposeBag = DisposeBag()
    
    // 외부에서 상태를 구독할 수 있게 공개된 Observable
    var state: Observable<State> {
        stateRelay.asObservable()
    }
    
    init () {
        action
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .fetchMusic:
                    self?.fetchMusic()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // 각 계절별 음악 리스트 받음
    private func fetchMusic() {
        let spring: Single<[Media]> = NetworkManager.shared.fetch(apiEndPoint: .music(term: .spring))
        let summer: Single<[Media]> = NetworkManager.shared.fetch(apiEndPoint: .music(term: .summer))
        let autumn: Single<[Media]> = NetworkManager.shared.fetch(apiEndPoint: .music(term: .autumn))
        let winter: Single<[Media]> = NetworkManager.shared.fetch(apiEndPoint: .music(term: .winter))
        
        Single.zip(spring, summer, autumn, winter)
            .subscribe(onSuccess: { [weak self] spring, summer, autumn, winter in
                let allMusicItems = [ spring, summer, autumn, winter ]
                self?.stateRelay.accept(State(musicItems: allMusicItems, errorMessage: ""))
            }, onFailure: { [weak self] error in
                if let networkError = error as? NetworkError {
                    self?.stateRelay.accept(
                        State(musicItems: [], errorMessage: networkError.errorDescription)
                    )
                } else {
                    self?.stateRelay.accept(State(musicItems: [], errorMessage:  "알 수 없는 오류가 발생했습니다."))
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MusicViewModel {
    enum Action {
        case fetchMusic
    }
    
    struct State {
        var musicItems: [[Media]]
        var errorMessage: String
    }
}
