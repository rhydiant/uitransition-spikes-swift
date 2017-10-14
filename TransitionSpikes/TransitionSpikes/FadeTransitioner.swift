//
//  FadeTransitioner.swift
//  TransitionSpikes
//
//  Created by Rhydian Thomas on 14/10/17.
//  Copyright © 2017 Rhydian Thomas. All rights reserved.
//

import UIKit


/// A `UIViewControllerTransitioningDelegate` using fading animations
class FadeTransitioner: NSObject, UIViewControllerTransitioningDelegate {

  // MARK: - Private properties

  private let fadeTransitionAnimator = FadeTransitionAnimator()



  // MARK: - UIViewControllerTransitioningDelegate

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return fadeTransitionAnimator
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return fadeTransitionAnimator
  }
  
}


/// A `UIViewControllerAnimatedTransitioning` performing fade in/out animations
class FadeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

  // MARK: - Private properties

  private var presenting: Bool = true



  // MARK: - UIViewControllerAnimatedTransitioning

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view,
      let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view else {
      return
    }

    // set the intial state

    if presenting {
      transitionContext.containerView.addSubview(toView)
      toView.alpha = 0
    } else {
      transitionContext.containerView.addSubview(fromView)
      fromView.alpha = 1
    }

    // animate to final state

    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
      if self.presenting {
        toView.alpha = 1
      } else {
        fromView.alpha = 0
      }
    }) { _ in
      self.presenting = !self.presenting
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }

}
