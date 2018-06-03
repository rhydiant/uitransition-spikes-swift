//
//  PrimaryViewController.swift
//  TransitionSpikes
//
//  Created by Rhydian Thomas on 14/10/17.
//  Copyright © 2017 Rhydian Thomas. All rights reserved.
//

import UIKit


class PrimaryViewController: UITableViewController, UIViewControllerTransitioningDelegate, UIViewControllerPreviewingDelegate {

  // MARK: - Private properties

  private let fadeTransitioner = FadeTransitioner()

  private var popTransitioner: PopTransitioner?

  

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    registerForPreviewing(with: self, sourceView: tableView)
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
      // peek
      present(SecondaryViewController(), animated: true)
    case 5:
      // custom
      let secondaryViewController = SecondaryViewController()
      secondaryViewController.modalPresentationStyle = .custom

      popTransitioner = PopTransitioner(viewController: secondaryViewController)
      secondaryViewController.transitioningDelegate = popTransitioner
      
      present(secondaryViewController, animated: true)
    default:
      // segues
      break
    }
  }



  // MARK: - UIViewControllerPreviewingDelegate

  func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                         viewControllerForLocation location: CGPoint) -> UIViewController? {
    if let indexPath = tableView.indexPathForRow(at: location) {
      previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
      return (indexPath.row == 4) ? SecondaryViewController() : nil
    }
    return nil
  }

  func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                         commit viewControllerToCommit: UIViewController) {
    present(SecondaryViewController(), animated: true)
  }


  // MARK: - Methods

  @IBAction func unwindSegue(segue: UIStoryboardSegue) { }

}

