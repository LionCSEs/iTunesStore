//
//  UIViewController+.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        guard !message.isEmpty else { return }
        let alertController = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}
