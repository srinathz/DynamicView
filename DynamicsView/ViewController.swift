//
//  ViewController.swift
//  DynamicsView
//
//  Created by srinath on 08/03/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    private var animator: UIDynamicAnimator!
    private var dragging: DynamicBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)
        dragging = DynamicBehavior(item: cardView, snapTo: view.center)
        animator.addBehavior(dragging)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pannedView))
        cardView.addGestureRecognizer(panGesture)
        cardView.isUserInteractionEnabled = true
    }

    @objc func pannedView(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            dragging.isEnabled = false
        case .changed:
            let translation = recognizer.translation(in: view)
            cardView.center = CGPoint(x: cardView.center.x + translation.x,
                                      y: cardView.center.y + translation.y)
            recognizer.setTranslation(.zero, in: view)
        case .ended, .cancelled, .failed:
            dragging.isEnabled = true
        default: break
        }
    }
}

final class DynamicBehavior: UIDynamicBehavior {
    
    private let snap: UISnapBehavior
    private let item: UIDynamicItem
    private var bounds: CGRect?
    
    var isEnabled: Bool = true {
        didSet {
            if isEnabled {
                addChildBehavior(snap)
            } else {
                removeChildBehavior(snap)
            }
        }
    }
    
    init(item: UIDynamicItem, snapTo: CGPoint) {
        self.item = item
        self.snap = UISnapBehavior(item: item, snapTo: snapTo)
        super.init()
        addChildBehavior(snap)
    }
    
    // MARK: UIDynamicBehavior
    
    override func willMove(to dynamicAnimator: UIDynamicAnimator?) {
        super.willMove(to: dynamicAnimator)
        bounds = dynamicAnimator?.referenceView?.bounds
    }
}
