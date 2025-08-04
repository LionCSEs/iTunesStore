# 🍎 iTunes Store App

> MVVM 아키텍처, UIKit 기반으로 구현된 iTunes Store 앱입니다.
iTunes Search API를 통해 홈 화면에서 계절별 음악들을 보여주고, 추가적으로 팟캐스트 및 영화 검색 기능을 제공합니다.

<br>

## ⏰ 프로젝트 일정 
- **시작일**: 2025/07/23 
- **종료일**: 2025/08/04

<br>

## 📌 주요 기능
### 1. 홈 화면
- iTunes Search API를 기반으로 음악 조회
- 봄, 여름, 가을, 겨울 계절별 섹션 분리
- 다크 모드 지원

### 2. 검색 결과 화면
- UISearchController로 음악 검색
- 영화, 팟캐스트별 섹션 분리
- 검색 결과 데이터가 없을 경우, 섹션별로 “검색 결과 없음” 표시
- Rx로 키보드 제어 및 검색 상태 바인딩

<br>

## 🛠 기술 스택
- Swift
- Xcode
- `UIKit`
- `MVVM Architecture`
- iOS 16.0 이상 지원
- `SnapKit` (레이아웃 제약 설정)
- `URLSession` (API 호출)
- RxSwift / RxCocoa (반응형 UI 처리)
- Then (초기화 축약 표현)
- Kingfisher (이미지 로딩)

<br>

## 📂 프로젝트 구조
```
📁 iTunesStore/
├── 📂 App/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── 📂 Data/Network/
│   ├── APIEndPoint.swift                             # API endPoint 설정
│   ├── NetworkError.swift                            # 네트워크 요청 중 발생할 수 있는 오류
│   └── NetworkManager.swift                          # API 데이터 파싱
├── 📂 Domain/Entity/
│   └── Media.swift                                   # 음악, 영화, 팟캐스트 데이터 구조
├── 📂 Presentation/
│   ├── 📂 Component/
│   │   ├── GradientView.swift                        # 그라데이션용 뷰
│   │   ├── SpringMusicAndSearchCell.swift            # 봄, 영화, 팟캐스트 셀
│   │   ├── SubTitleLabel.swift                       # 서브 타이블 라벨
│   │   └── TitleLabel.swift                          # 타이블 라벨
│   ├── 📂 Music/
│   │   ├── 📂 Model/
│   │   │   ├── MusicItem.swift                       
│   │   │   └── MusicSection.swift                    # 계절별 음악 세션 정의
│   │   ├── 📂 View/
│   │   │   ├── ListMusicCell.swift                   # 여름, 가을, 겨울 셀
│   │   │   └── MusicSectionHeaderView.swift          # 섹션 헤더 뷰
│   │   ├── MusicViewController.swift                 # 홈 화면 구성
│   │   └── MusicViewModel.swift                      # 음악 데이터 관리
│   ├── 📂 Search/
│   │   ├── 📂 Model/
│   │   │   ├── SearchItem.swift                       
│   │   │   └── SearchSection.swift                   # 영화 및 팟캐스트별 음악 세션 정의
│   │   ├── 📂 View/
│   │   │   └── SearchSectionHeaderView.swift         # 섹션 헤더 뷰
│   │   ├── SearchViewController.swift                # 검색 결과 화면 구성
│   │   └── SearchViewModel.swift                     # 검색 데이터 관리
│   ├── 📂 Utils/Extention/
│   │   ├── UIImageView+.swift                        # 이미지 로딩
│   │   ├── UIViewController+.swift                   # alert 창 띄우기
│   └── LayoutManager.swift                           # 컴포지셔널 레이아웃 관리
```

<br>

## 🔁 API 정보
- iTunes Search API: https://itunes.apple.com/search
- 음악 조회 예: https://itunes.apple.com/search?country=kr&media=music&term=봄&entity=song
- 영화 검색 예: https://itunes.apple.com/search?country=kr&media=movie&term=marvel&entity=movie
- 팟캐스트 검색 예: https://itunes.apple.com/search?country=kr&media=podcast&term=marvel&entity=podcast

<br>

## 💻 실행 화면
- 추가 예정

<br>

## 🐞 프로젝트 설명
구현 과정에서 ViewController가 무거워지는 것을 방지하고 책임을 분리하기 위해 MVVM 패턴을 적용하였고, 이 과정에서 데이터 바인딩을 수월하게 하기 위해 RxSwift를 도입했습니다. 

<br>

### 추상화
- Music, Movie, Podcast를 Media 타입으로 추상화하여 Network의 중복 로직 최소화

### 재사용성
- 중복되는 UI들의 컴포넌트화
- GradientView UI 컴포넌트 재사용
- SpringMusicAndSearchCell: 봄, 검색 결과 셀
- SubTitleLabel: 아티스트 이름 등 
- TitleLabel: 노래/팟캐스트/영화 제목 등 
- ErrorAlert를 extension으로 분리하여 각 화면에서 재사용

### 사용성 UX
- 셀 배경에 그림자 추가, 다크모드 적용
- 이미지 로딩 Indicator 표시, 이미지 URL이 유효하지 않을 경우 기본 이미지 설정
- 에러 발생 시, Alert로 메시지 표시
- 화면 터치 시 키보드 내림

<br>

### 메모리 관리 분석
- 추가 예정

<br>

## 🎯 개발 목적
- iTunes API를 활용하여 Rx 기반의 검색 기능과 섹션별 데이터 분리 처리 학습
- MVVM 구조, Rx 데이터 바인딩, UI 상태 변화 처리 등 실무에 필요한 기술 경험을 쌓는 것이 목표
- 사용자 친화적인 검색 UI 구현을 통해 실제 서비스 수준의 앱 구성 능력 강화

<br>

## ✨ 향후 개선 아이디어
- 최근 검색어 저장 및 삭제 기능 추가
- 검색어 자동완성 기능 적용
- 즐겨찾기 기능 및 사용자별 데이터 저장
- Unit Test & UI Test 구성으로 테스트 커버리지 향상

<br>

## 📦 설치 및 실행 방법
1. Xcode 설치
2. 프로젝트 클론
```bash
git clone https://github.com/Pjh01/iTunesStore.git
```
3. Xcode에서 프로젝트 열기
4. 시뮬레이터에서 실행 및 확인
