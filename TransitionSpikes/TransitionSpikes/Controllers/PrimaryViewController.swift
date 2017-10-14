//
//  PrimaryViewController.swift
//  TransitionSpikes
//
//  Created by Rhydian Thomas on 14/10/17.
//  Copyright © 2017 Rhydian Thomas. All rights reserved.
//

import UIKit


class PrimaryViewController: UITableViewController, UIViewControllerTransitioningDelegate {

  // MARK: - Private properties

  private let fadeTransitioner = FadeTransitioner()

  private var popTransitioner: PopTransitioner?

  

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }


  
  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    switch indexPath.row {
    case 0:
      show(SecondaryViewController(), sender: nil)
    case 1:
      showDetailViewController(SecondaryViewController(), sender: nil)
    case 2:
      present(SecondaryViewController(), animated: true)
    case 3:
      navigationController?.pushViewController(SecondaryViewController(), animated: true)
    case 4:
      // custom
      let secondaryViewController = SecondaryViewController()
      secondaryViewController.modalPresentationStyle = .custom

      popTransitioner = PopTransitioner(viewController: secondaryViewController)
      secondaryViewController.transitioningDelegate = popTransitioner
      
      present(secondaryViewController, animated: true)
    default:
      // segue
      break
    }
  }

}

