//
//  CBKBaseViewController.swift
//  aarqADAM-iOS
//
//  Created by Alex Hernández on 10/09/2019.
//

import UIKit
//import aarqCore

public protocol CBKBaseViewControllerAccessibility {
    func setNavBarAccessibility()
}

open class CBKBaseViewController: UIViewController {
    open var deeplinkURL: URL?
    open var deeplinkBF: String?
    open var deeplinkOperativa: String?

    open func handleDL(url: URL, bf: String, operativa: String) {
        self.deeplinkURL = url
        self.deeplinkBF = bf
        self.deeplinkOperativa = operativa
    }

    open func clearDL() {
        self.deeplinkURL = nil
        self.deeplinkBF = nil
        self.deeplinkOperativa = nil
    }

    var statusBarStyle: UIStatusBarStyle = .default
    var statusBarHidden: Bool = false

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNavBarAccessibility()
    }

    // MARK: - Status Bar
    // This methods must be calleds before viewWillAppear
    open func setStatusBarBlack(_ isModal: Bool) {
        self.modalPresentationCapturesStatusBarAppearance = isModal
        self.statusBarStyle = .default
    }

    open func setStatusBarWhite(_ isModal: Bool) {
        self.modalPresentationCapturesStatusBarAppearance = isModal
        self.statusBarStyle = .lightContent
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    override open var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }

    // MARK: - Orientation
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override open var shouldAutorotate: Bool {
        if #available(iOS 11, *) {
            return false
        }
        return true
    }

    // MARK: - Accessibility
    public func setNavBarAccessibility() {
        guard let _ = self.navigationItem.leftBarButtonItem else { return }
    }
}

extension UIViewController {

    // Show modal VC from right (<=)
    func presentDetailFromRight(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)

        present(viewControllerToPresent, animated: false)
    }

    // Dissmis modal VC from left (=>)
    func dismissDetailFromLeft(completion: (() -> Void)? = nil) {

        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft

        if let window = self.view.window {
            window.layer.add(transition, forKey: kCATransition)
        } else if let window = self.presentedViewController?.view.window {
            window.layer.add(transition, forKey: kCATransition)
        }

        dismiss(animated: false) {
            if let completion = completion {
                completion()
            }
        }
    }
}
