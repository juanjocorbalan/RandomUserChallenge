//
//  ZoomAnimator.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 07/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit

protocol Zoomable where Self: UIViewController {
    var zoomableViewFrame: CGRect { get }
}

class ZoomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  private let duration = 0.8
  private var originFrame = CGRect.zero
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    if let fromNavVC = transitionContext.viewController(forKey: .from) as? UINavigationController,
        let fromVC = fromNavVC.viewControllers.last as? Zoomable {
        originFrame = fromVC.zoomableViewFrame
    }
    
    let containerView = transitionContext.containerView
    let toView = transitionContext.view(forKey: .to)!
    
    let initialFrame = originFrame
    let finalFrame = toView.frame
    
    let xScaleFactor = initialFrame.width / finalFrame.width
    let yScaleFactor = initialFrame.height / finalFrame.height
    let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
    
    toView.transform = scaleTransform
    toView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)

    containerView.addSubview(toView)
    containerView.bringSubviewToFront(toView)
    
    UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, animations: {
        toView.transform = .identity
        toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
    }, completion: { _ in
      transitionContext.completeTransition(true)
    })
  }
}

// MARK: - UIViewControllerTransitioningDelegate

extension ZoomAnimator: UIViewControllerTransitioningDelegate {
 
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
