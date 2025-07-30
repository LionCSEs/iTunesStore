//
//  ViewController.swift
//  iTunesStore
//
//  Created by Milou on 7/28/25.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
      super.viewDidLoad()
      testNetworkService()
    }
  
  private func testNetworkService() {
    let networkService = NetworkServiceImp()
    let endpoint = iTunesEndpoint.seasonMusic(season: .spring)
    
    networkService.fetch(endPoint: endpoint)
      .observe(on: MainScheduler.instance)
      .subscribe(
        onSuccess: { (response: MusicResponseDTO) in
          print("✅ Success: \(response.results.count)개의 음악")
          response.results.forEach { music in
            print("- \(music.trackName) by \(music.artistName)")
          }
        },
        onFailure: { error in
          print("❌ Error: \(error.localizedDescription)")
        }
      )
      .disposed(by: disposeBag)
  }
}
