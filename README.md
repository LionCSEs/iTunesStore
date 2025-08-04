# **iTunesStore - 검색 기반 미디어 콘텐츠 탐색 앱**

## **📸 구현 화면**

| iPhone Recording | iPad Screenshot |
|------------------|-----------------|
| <img src="https://github.com/user-attachments/assets/7f2d1950-9882-4434-bcd8-4934b78477f7"/> | <img src="https://github.com/user-attachments/assets/43d9702b-6e55-496f-bbf8-04d9b0ca5a40" height="400px" /> |


---

## **📐 프로젝트 아키텍처**

- **패턴**: MVVM (Model - View - ViewModel)
- **비동기 처리**: RxSwift, RxCocoa, RxRelay
- **UI 구성**: UIKit + Compositional Layout
- **레이아웃 도구**: SnapKit, Then
- **네트워킹**: Alamofire
- **기반 API**: iTunes Search API (https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html)

### **디렉토리 구조**

```
├── App
│   ├── AppDelegate.swift
│   ├── LaunchScreen.storyboard
│   └── SceneDelegate.swift
├── Model
│   ├── MediaInfo.swift
│   ├── Movie.swift
│   ├── Music.swift
│   └── Podcast.swift
└── Network
│   ├── NetworkService.swift
│   └── SearchResponse.swift
├── Presentation
│   ├── Home
│   │   ├── View
│   │   │   ├── BigCell.swift
│   │   │   ├── HeaderView.swift
│   │   │   ├── HomeView.swift
│   │   │   ├── HomeViewController.swift
│   │   │   └── LittleCell.swift
│   │   └── ViewModel
│   │       └── HomeViewModel.swift
│   └── SearchResults
│       ├── View
│       │   ├── SearchResultCell.swift
│       │   ├── SearchResultHeaderView.swift
│       │   └── SearchResultViewController.swift
│       └── ViewModel
│           └── SearchResultViewModel.swift
├── Resource
│   └── Assets.xcassets
└── Info.plist
```

---

## **💡 주요 설계 및 구현 의사결정**

### **✅ 재사용성 (Reusability)**

- MediaInfo 구조체를 도입하여 Music, Movie, Podcast 모델을 공통 인터페이스로 변환 → 뷰에 바인딩되는 모델을 하나로 통합.
- SearchResultCell, LittleCell, BigCell 등 여러 Cell에서 MediaInfo를 통해 공통 UI 구성 가능.
- SearchResultViewController에서도 MediaInfo 기반의 공통 뷰 구성으로 통합된 로직 구현.

### **✅ 추상화 (Abstraction)**

- 개별 모델(Music, Movie, Podcast)의 디코딩 구조는 유지하되, ViewModel에서는 MediaInfo만 다루도록 하여 뷰에 대한 추상화.
- 뷰에서 직접 모델에 접근하지 않고 ViewModel이 가공한 추상화된 데이터만 사용 → UI 로직과 데이터 로직의 명확한 분리.

---

## **🧠 메모리 관리 분석**

- ✅ **RxSwift의 DisposeBag**을 모든 ViewModel과 ViewController에서 적절히 사용하여 메모리 누수 방지.
- ✅ **SearchResultHeaderView** 내부에서 disposeBag을 반복적으로 생성하지 않도록 주의하여 Rx 바인딩 시점과 메모리 주기 관리.
- 🔍 **Xcode Instruments** 분석 결과, Retain Cycle 및 메모리 누수 없음 확인.
- <img width="1317" height="957" alt="스크린샷 2025-08-04 17 00 36" src="https://github.com/user-attachments/assets/d5765082-07a4-4b34-9c83-46d39ae91e6b" />


---

## **✨ 추가 구현 사항**

- 검색 화면 상단에 UISegmentedControl을 추가하여 **전체 / 영화 / 팟캐스트** 필터링 기능 구현
- UISearchController.searchResultsController를 활용하여 검색 결과를 전용 ViewController로 분리
- 미디어 타입에 따라 셀 내부에 콘텐츠 타입(영화/팟캐스트) 레이블 표시 (모두 탭에서만)
- UICollectionViewCompositionalLayout을 사용한 반응형 레이아웃 구성으로 다양한 디바이스 대응

---

## **🛠 사용한 라이브러리 및 선택 이유**

| **라이브러리** | **역할** | **선택 이유** |
| --- | --- | --- |
| RxSwift / RxCocoa / RxRelay | 비동기 상태 관리 | 선언적 UI 바인딩, ViewModel 구조와의 궁합 |
| Alamofire | 네트워크 통신 | 간결한 API 호출, 에러처리와 디코딩 통합 |
| SnapKit | AutoLayout | 코드 기반 UI 레이아웃의 생산성 향상 |
| Then | 객체 초기화 단축 문법 | UI 구성 코드 가독성 향상 |

---

## **📱 UX / UI 설계 고려**

- SearchResultHeaderView에 현재 검색어를 실시간 반영하여 사용자 맥락 제공
- iPad 및 다양한 사이즈 대응을 위한 반응형 컴포지셔널 레이아웃 구성
- 스크롤 시 헤더 고정, 검색어 즉시 반영 등 Apple Music 유사한 탐색 흐름 제공
