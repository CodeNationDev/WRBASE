//
//  CBKContextualMenuViewController.swift
//  Commons_APPCBK
//
//  Created by Alexandre Martinez on 31/7/17.
//  Copyright © 2017 opentrends. All rights reserved.
//

import UIKit
//import aarqCore

// MARK: - Contextual Menu Option Struct
public struct CBKContextualMenuOption {
    var icon: String
    var title: String

    public init(withIcon: String, andTitle: String) {
        icon = withIcon
        title = andTitle
    }

    public func isEqualToAnother(_ menuOption: CBKContextualMenuOption) -> Bool {
        return self.icon == menuOption.icon && self.title == menuOption.title
    }
}

// MARK: - CBKContextualMenuViewController Protocol
@objc public protocol CBKContextualMenuViewControllerDelegate {
    func pressed(option: Int)
    @objc optional func isNeedCheckNetwork(option: Int) -> Bool
}

public protocol CBKContextualMenuViewControllerDataSource {
    func contextualMenuOptionList() -> [CBKContextualMenuOption]
}

// MARK: - CBKContextualMenuViewController Class
public class CBKContextualMenuViewController: CBKBaseViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var menuContentView: UIView!
    @IBOutlet weak var optionsContentView: UIView!
    @IBOutlet weak var bottomContentView: CBKCurvedView!
    @IBOutlet weak var menuContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var curvedView: CBKCurvedView!

    @IBOutlet weak var gradientViewTop: UIView!
    @IBOutlet weak var gradientViewBottom: UIView!
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelBottomSpaceConstraint: NSLayoutConstraint!

    // MARK: - Class Variables
    private let STATICCELLHEIGHT = 45.0
    private let STATICMENUHEIGHT = 146.0
    private var menuTitle: String = ""
    private var options: [CBKContextualMenuOption] = []
    public var contextualMenuViewControllerDelegate: CBKContextualMenuViewControllerDelegate?
    public var contextualMenuViewControllerDataSource: CBKContextualMenuViewControllerDataSource?
    private let cbkBlue = UIColor(named: "BlueCaixa1")!

    // MARK: - Class Methods
    public init(menuTitle: String, options: [CBKContextualMenuOption], delegate: CBKContextualMenuViewControllerDelegate?) {
        self.menuTitle = menuTitle
        self.options = options

        if delegate != nil {
            self.contextualMenuViewControllerDelegate = delegate
        }

        super.init(nibName: "CBKContextualMenuViewController", bundle: .main)
    }

    public init(menuTitle: String,
                delegate: CBKContextualMenuViewControllerDelegate?,
                dataSource: CBKContextualMenuViewControllerDataSource?) {
        self.menuTitle = menuTitle

        if delegate != nil {
            self.contextualMenuViewControllerDelegate = delegate
        }

        if dataSource != nil {
            self.contextualMenuViewControllerDataSource = dataSource
        }

        super.init(nibName: "CBKContextualMenuViewController", bundle: .main)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGestureRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(closeButtonPressed(_:)))
        swipeGestureRecognizerUp.direction = .up
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(swipeGestureRecognizerUp)
        
        self.titleLabel.text = self.menuTitle

        if self.menuTitle == "" {
            self.titleLabelHeightConstraint.constant = 0
            self.titleLabelBottomSpaceConstraint.constant = 0
        }

        self.titleLabel.setNeedsUpdateConstraints()

        tableView.register(UINib(nibName: "CBKContextualMenuOptionCell", bundle: .main), forCellReuseIdentifier: "CBKContextualMenuOptionCell")

        self.menuContentView.backgroundColor = cbkBlue
        self.optionsContentView.backgroundColor = UIColor.clear

        createGradientBottom()
        createGradientTop()

        

        self.setupAccessibility()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.alpha = 0
        self.menuContentView.transform = CGAffineTransform(translationX: 0.0, y: -self.view.frame.size.height)
        self.curvedView.transform = CGAffineTransform(translationX: 0.0, y: -self.view.frame.size.height)

        if let contextualMenuOptionList = contextualMenuViewControllerDataSource?.contextualMenuOptionList() {
            self.options = contextualMenuOptionList
        }
    }

    override public func viewDidAppear(_ animated: Bool) {
        openingAnimation()
        LoggerManager.shared.log(message: "ContextualMenu opened")
    }

    override public func viewDidLayoutSubviews() {
        setMenuHeight()
    }

    private func setupAccessibility() {
        self.closeButton.isAccessibilityElement = true
        self.closeButton.accessibilityTraits = UIAccessibilityTraits.button
        let stringClose = "caixabank_accessibilitat_ios_basics_topbar_accion_cerrar"
        
       
    }

    private func setMenuHeight() {
        let optionsHeight = Double(self.options.count) * STATICCELLHEIGHT
        let fixedHeight = Double(self.tableView.frame.origin.y + self.closeButton.frame.size.height)
        var menuHeight = optionsHeight + fixedHeight

        if menuHeight > Double(self.view.frame.size.height - 30) {
            menuHeight = Double(self.view.frame.size.height - 30)
            self.tableView.isScrollEnabled = true
        } else {
            self.tableView.isScrollEnabled = false
        }

        self.menuContentViewHeight.constant = CGFloat(menuHeight)
        self.view.layoutIfNeeded()
    }

    private func openingAnimation() {
        self.view.alpha = 1
        self.tableView.alpha = 0
        self.closeButton.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            self.menuContentView.transform = CGAffineTransform(translationX: 0.0, y: 0)
            self.curvedView.transform = CGAffineTransform(translationX: 0.0, y: 0)
            self.tableView.alpha = 0.8
            self.closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
            self.closeButton.alpha = 0.6
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
                self.menuContentView.transform = CGAffineTransform(translationX: 0.0, y: -10)
                self.curvedView.transform = CGAffineTransform(translationX: 0.0, y: -10)
                self.tableView.alpha = 1.0
                self.closeButton.alpha = 1.0
            }, completion: nil)
        })
    }

    private func endingAnimation(completionAnimation: (() -> ())?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = UIColor.clear
            self.menuContentView.transform = CGAffineTransform(translationX: 0.0, y: -1000)
            self.curvedView.transform = CGAffineTransform(translationX: 0.0, y: -1000)
            self.closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
            self.tableView.alpha = 0.0
            self.closeButton.alpha = 0.0
        }, completion: { (finished: Bool) in
            self.dismiss(animated: false, completion: {
                completionAnimation?()
            })
        })
    }

    private func createGradientTop() {
        gradientViewTop.backgroundColor = .clear
        let gradient = CAGradientLayer()
        gradient.frame = gradientViewTop.bounds
        gradient.colors = [cbkBlue.cgColor, cbkBlue.withAlphaComponent(0).cgColor]
        gradientViewTop.layer.insertSublayer(gradient, at: 0)
    }
    private func createGradientBottom() {
        gradientViewBottom.backgroundColor = .clear
        let gradient = CAGradientLayer()
        gradient.frame = gradientViewBottom.bounds
        gradient.colors = [cbkBlue.withAlphaComponent(0).cgColor, cbkBlue.cgColor]
        gradientViewBottom.layer.insertSublayer(gradient, at: 0)
    }

    // MARK: - UITableView Delegate Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(STATICCELLHEIGHT)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "CBKContextualMenuOptionCell", for: indexPath) as? CBKContextualMenuOptionCell ?? CBKContextualMenuOptionCell()
        cell.iconLabel.image = UIImage(named: option.icon)?.withRenderingMode(.alwaysTemplate)
        cell.titleLabel.text = option.title
        cell.isAccessibilityElement = true
        cell.iconLabel.isAccessibilityElement = false
        cell.titleLabel.isAccessibilityElement = false
        cell.accessibilityTraits = UIAccessibilityTraits.button
        cell.accessibilityLabel = cell.titleLabel.text ?? ""

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let checkNetwork: Bool = self.contextualMenuViewControllerDelegate?.isNeedCheckNetwork?(option: indexPath.row) {
            endingAnimation(completionAnimation: {
                self.contextualMenuViewControllerDelegate?.pressed(option: indexPath.row)
            })
        } else {
            endingAnimation(completionAnimation: {
                self.contextualMenuViewControllerDelegate?.pressed(option: indexPath.row)
            })
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var existsClippedCellTop = false
        var existsClippedCellBott = false
        let indexPathsForVisibleRows = self.tableView.indexPathsForVisibleRows ?? []
        for indexPath in indexPathsForVisibleRows {
            let cellRect = self.tableView.rectForRow(at: indexPath)
            if !self.tableView.bounds.contains(cellRect) {
                let cellCorner = CGPoint(x: cellRect.origin.x, y: cellRect.origin.y)
                if self.tableView.bounds.contains(cellCorner) {
                    gradientViewBottom.isHidden = false
                    existsClippedCellBott = true
                } else {
                    gradientViewTop.isHidden = false
                    existsClippedCellTop = true
                }
            }
        }
        if !existsClippedCellTop {
            gradientViewTop.isHidden = true
        }
        if !existsClippedCellBott {
            gradientViewBottom.isHidden = true
        }
    }

    // MARK: - Actions
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        LoggerManager.shared.log(message: "ContextualMenu closed")
        endingAnimation(completionAnimation: nil)
    }
}
