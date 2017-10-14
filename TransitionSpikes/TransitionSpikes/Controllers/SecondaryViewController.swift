//
//  SecondaryViewController.swift
//  TransitionSpikes
//
//  Created by Rhydian Thomas on 14/10/17.
//  Copyright © 2017 Rhydian Thomas. All rights reserved.
//

import UIKit

class SecondaryViewController: UIViewController {

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    // add a dismiss button

    let dismissButton = UIButton(type: .custom)
    view.addSubview(dismissButton)

    dismissButton.setTitle("Dismiss", for: .normal)

    dismissButton.setTitleColor(.black, for: .normal)
    dismissButton.setTitleColor(.darkGray, for: .highlighted)
    dismissButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 24)

    dismissButton.translatesAutoresizingMaskIntoConstraints = false
    dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    dismissButton.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
  }



  // MARK: - Private methods

  @objc private func didTapDismiss() {
    if let navigationController = navigationController {
      navigationController.popViewController(animated: true)
    } else {
      dismiss(animated: true, completion: nil)
    }
  }
}
