//
//  CustomSegue.swift
//  TransitionSpikes
//
//  Created by Rhydian Thomas on 3/6/18.
//  Copyright © 2018 Rhydian Thomas. All rights reserved.
//

import UIKit


// MARK: - CustomPresentingSegue

class CustomPresentingSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {

    // MARK: - UIStoryboardSegue

    override func perform() {
        destination.modalPresentationStyle = .custom
        destination.transitioningDelegate = self
        source.present(destination, animated: true, completion: nil)
    }


    // MARK: - UIViewControllerTransitioningDelegate

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopPresentingTransitionAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopDismissingTransitionAnimator()
    }

}


// MARK: - CustomDismissSegue

class CustomDismissSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {

    // MARK: - UIStoryboardSegue

    override func perform() {
        source.modalPresentationStyle = .custom
        source.transitioningDelegate = self
        source.dismiss(animated: true, completion: nil)
    }


    // MARK: - UIViewControllerTransitioningDelegate

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopPresentingTransitionAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopDismissingTransitionAnimator()
    }

}
