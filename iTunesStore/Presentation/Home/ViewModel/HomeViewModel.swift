//
//  HomeViewModel.swift
//  iTunesStore
//
//  Created by 김우성 on 7/29/25.
//

import Foundation
import RxCocoa
import RxSwift

final class HomeViewModel {
    
    // MARK: - 상태 정의
    struct State {
        var springInfos: [MediaInfo] = []
        var summerInfos: [MediaInfo] = []
        var autumnInfos: [MediaInfo] = []
        var winterInfos: [MediaInfo] = []
    }
    
    // MARK: - 액션 정의 (뷰에서 전달됨)
    enum Action {
        case fetchData
    }
    
    // MARK: - Rx 구성요소
    let disposeBag = DisposeBag() // 메모리 누수 방지용 쓰레기통
    let actionRelay = PublishRelay<Action>() // 뷰에서 전달하는 액션이 들어오는 통로
    let stateRelay = BehaviorRelay<State>(value: State()) // 상태 데이터를 갖고 있으며 구독자에게 전달됨
    
    // 뷰에서 구독할 수 있도록 Driver 형태로 노출
    var stateDriver: Driver<State> {
        stateRelay.asDriver()
    }
    
    // MARK: - 초기 바인딩
    init() {
        actionRelay // 뷰에서 .accept(.fetchData)를 호출하면
            .flatMap { action in
                switch action {
                case .fetchData:
                    // 네트워크 요청 4개를 zip으로 병합하여 하나의 State로 반환
                    return Self.fetchAllSeasons()
                }
            }
            .bind(to: stateRelay) // 생성된 State를 stateRelay에 바인딩하여 상태 업데이트
            .disposed(by: disposeBag)
    }
    
    // MARK: - 시즌별 데이터를 요청하는 함수
    private static func fetchSeason(term: String, limit: Int) -> Observable<[MediaInfo]> {
        NetworkService.shared
            .fetchMedia(term: term, mediaType: "music", limit: limit) // 음악 검색 API 요청
            .map { (musics: [Music]) in musics.map(MediaInfo.from) } // [Music] → [MediaInfo]로 매핑
    }
    
    // MARK: - 전체 시즌 데이터 요청을 zip으로 병합
    private static func fetchAllSeasons() -> Observable<State> {
        let spring = fetchSeason(term: "봄", limit: 4)
        let summer = fetchSeason(term: "여름", limit: 49)
        let autumn = fetchSeason(term: "가을", limit: 49)
        let winter = fetchSeason(term: "겨울", limit: 49)
        
        return Observable.zip(spring, summer, autumn, winter) // 4개 요청 모두 완료되면 결과 결합
            .map { spring, summer, autumn, winter in
                State(
                    springInfos: spring,
                    summerInfos: summer,
                    autumnInfos: autumn,
                    winterInfos: winter
                ) // State로 구성하여 반환
            }
    }
    /// 뷰에서 .accept(.fetchData) 호출
    /// → actionRelay가 그 이벤트 방출
    /// → flatMap에서 네트워크 요청 4개 진행
    /// → zip으로 결과 병합
    /// → State 생성
    /// → bind로 stateRelay에 전달
    /// → stateDriver를 통해 뷰에서 상태 감지 & UI 업데이트
}
