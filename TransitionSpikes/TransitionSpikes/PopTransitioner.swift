//
//  PopTransitioner.swift
//  TransitionSpikes
//
//  Created by Rhydian Thomas on 14/10/17.
//  Copyright © 2017 Rhydian Thomas. All rights reserved.
//

import UIKit


/// A `UIViewControllerTransitioningDelegate` using pop animations
///
/// The `PopTransitioner` coordinates the transition using `PanInteractionTransitioner`
/// and animators; `PopPresentingTransitionAnimator` and `PopDismissingTransitionAnimator`
///
class PopTransitioner: NSObject, UIViewControllerTransitioningDelegate {

  // MARK: - Private properties

  private let panInteractionTransitioner: PanInteractionTransitioner



  // MARK: - Lifecycle

  init(viewController: UIViewController) {
    panInteractionTransitioner = PanInteractionTransitioner()
    panInteractionTransitioner.viewController = viewController
  }



  // MARK: - UIViewControllerTransitioningDelegate

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return PopPresentingTransitionAnimator()
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return PopDismissingTransitionAnimator()
  }

  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return panInteractionTransitioner.interactionInProgress ? panInteractionTransitioner : nil
  }
  
}


/// A `UIPercentDrivenInteractiveTransition` to perform interactive transitions using a pan gesture
class PanInteractionTransitioner: UIPercentDrivenInteractiveTransition {

  // MARK: - Properties

  var interactionInProgress = false

  weak var viewController: UIViewController? {
    didSet {
      guard let viewController = viewController else { return }

      let gesture = UIPanGestureRecognizer(target: self, action:  #selector(handleGesture(_:)))
      viewController.view.addGestureRecognizer(gesture)
    }
  }



  // MARK: - Private properties

  private var shouldCompleteTransition = false



  // MARK: - Private methods

  @objc private func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
    guard let superview = gestureRecognizer.view?.superview else { return }

    var progress = (gestureRecognizer.translation(in: superview).y / 200)
    progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))

    switch gestureRecognizer.state {
    case .began:
      interactionInProgress = true
      viewController?.dismiss(animated: true, completion: nil)
    case .changed:
      shouldCompleteTransition = progress > 0.5
      update(progress)
    case .cancelled:
      interactionInProgress = false
      cancel()
    case .ended:
      interactionInProgress = false
      if shouldCompleteTransition {
        finish()
      } else {
        completionSpeed = 0.999 // https://stackoverflow.com/questions/19626374/ios-7-custom-transition-glitch
        cancel()
      }
    default:
      break
    }
  }
}


/// A `UIViewControllerAnimatedTransitioning` performing pop in animations
class PopPresentingTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

  // MARK: - UIViewControllerAnimatedTransitioning

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view else {
      return
    }

    // set the intial state

    let containerView = transitionContext.containerView

    // add an overlay

    let overlay = UIView(frame: .zero)
    overlay.backgroundColor = .black
    containerView.addSubview(overlay)
    overlay.frame = containerView.bounds
    overlay.alpha = 0

    // add the toView

    containerView.addSubview(toView)

    toView.translatesAutoresizingMaskIntoConstraints = false
    toView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    toView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    toView.widthAnchor.constraint(equalToConstant: containerView.bounds.width - 64).isActive = true
    toView.heightAnchor.constraint(equalToConstant: 200).isActive = true

    // transform

    toView.transform = CGAffineTransform(scaleX: 0, y: 0)

    // shaddow

    toView.layer.masksToBounds = false
    toView.layer.shadowColor = UIColor.black.cgColor
    toView.layer.shadowOpacity = 0.5
    toView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)

    // corners

    toView.layer.cornerRadius = 8


    // animate to final state

    UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 4.0,
                   options: .curveEaseInOut,
                   animations: {
                    overlay.alpha = 0.3
                    toView.transform = CGAffineTransform.identity
    }) { _ in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }

  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }

}


/// A `UIViewControllerAnimatedTransitioning` performing pop out animations
class PopDismissingTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

  // MARK: - UIViewControllerAnimatedTransitioning

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view else {
      return
    }

    // set the intial state

    transitionContext.containerView.addSubview(fromView)
    fromView.transform = CGAffineTransform.identity

    // animate to final state

    UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                   delay: 0,
                   options: .curveEaseInOut,
                   animations: {
                    transitionContext.containerView.alpha = 0
                    fromView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
    }) { _ in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
}
