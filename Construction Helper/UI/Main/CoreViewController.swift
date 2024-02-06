//
//  CoreViewController.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 03/02/2024.
//
import RealmSwift
import UIKit

class CoreViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var initialLoadingView: UIView!
    @IBOutlet weak var bottomViewWrapper: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var uiTabBar: UITabBar!
    @IBOutlet weak var uiTabBarHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var uiTabBarViewHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var warningViewHeightConstraints: NSLayoutConstraint!
    
    private var contentNavigationController:  UINavigationController!
    private var coreViewModel = CoreViewModel()
    private var isAnimatingBottomPanels = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uiTabBar.delegate = self
        
        
        setupListeners()
        
        setupStatusBar()
        
        setupWarningView()
        
    }
    
    private func setupStatusBar() {
        DispatchQueue.main.async {
            UIApplication.statusBarBackgroundColor = UIColor.navbarColorDark()
        }
    }
    
    private func setupTabBar() {
        
        uiTabBar.items?.removeAll()
        
        let tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeIcon"), selectedImage: UIImage(named: "homeIcon"))
        uiTabBar.items?.append(tabBarItem)
        
        let tabBarItem2 = UITabBarItem(title: "Projects", image: UIImage(named: "projectsIcon"), selectedImage: UIImage(named: "projectsIcon"))
        uiTabBar.items?.append(tabBarItem2)
        
        guard let tabBarItems = uiTabBar?.items else { return }

        UITabBar.appearance().barTintColor = UIColor.navbarColorDark()
        UITabBar.appearance().tintColor = UIColor.whiteWithAlpha(1.0)
        UITabBar.appearance().selectedImageTintColor = UIColor.backgroundColour()
        
        uiTabBar.selectedItem = tabBarItems.first
        uiTabBar.layer.borderWidth = 0
        uiTabBar.clipsToBounds = true
                
        let rootVC = ViewFactory.createView(screenName: .HOME)
        guard let rootVC = rootVC else { return }
        self.contentNavigationController?.viewControllers = [rootVC]
        NotificationCenter.default.post(name: Notifications.ShowView, object: rootVC)
    }
    
    private func setupNavigationBar()  {
        self.contentNavigationController.navigationBar.tintColor = UIColor.backgroundColour()
        self.contentNavigationController.navigationBar.barTintColor = UIColor.navbarColorDark()
    }
    
    private func setupWarningView() {
        hideWarningView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "embedContent" {
            self.contentNavigationController = segue.destination as? UINavigationController
            self.contentNavigationController!.delegate = self
            showHideBackButton(hide: true)
            setupTabBar()
            setupNavigationBar()
        }
    }
    
    private func showHideBackButton(hide: Bool) {
        self.contentNavigationController?.topViewController?.navigationItem.setHidesBackButton(hide, animated: true)
        navigationItem.hidesBackButton = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupListeners() {
        let nc = NotificationCenter.default
        
        nc.addObserver(self, selector: #selector(CoreViewController.presentView(_:)), name: Notifications.PresentView, object: nil)
        nc.addObserver(self, selector: #selector(CoreViewController.showView(_:)), name: Notifications.ShowView, object: nil)
        nc.addObserver(self, selector: #selector(CoreViewController.showViewAsPopover(_:)), name: Notifications.ShowViewAsPopover, object: nil)
        nc.addObserver(self, selector: #selector(CoreViewController.showWarning_(_:)), name: Notifications.ShowWarning, object: nil)
        nc.addObserver(self, selector: #selector(CoreViewController.dismissAllPopoverControllers(_:)), name: Notifications.DismissAllPopovers, object: nil)
        nc.addObserver(self, selector: #selector(viewScrolledDown(_:)), name: Notifications.ViewScrolledDown, object: nil)
        nc.addObserver(self, selector: #selector(viewScrolledUp(_:)), name: Notifications.ViewScrolledUp, object: nil)
    }
    
    @objc func presentView(_ notification: Notification) {
        guard let vc = notification.object as? UIViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        present(vc: vc)
    }
    
    private func present(vc: UIViewController?) {

        guard let vc = vc else { return }
        dismissAllPopoverControllers(to: type(of: vc))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func showView(_ notification: Notification) {
        
        guard var vc: UIViewController? = notification.object as? UIViewController else { return }
        
        if vc is HomeVC {
            uiTabBar.selectedItem = uiTabBar.items?.first(where: { $0.title == "Home" })
        }
        
        if vc is ProjectsVC {
            uiTabBar.selectedItem = uiTabBar.items?.first(where: { $0.title == "Projects" })
        }
        
        push(vc: &vc)
    }
    
    private func push(vc: inout UIViewController?) {

        guard
            vc != nil,
            let navController = self.contentNavigationController else {
            return
        }

        let currentController = navController.topViewController
        
        if canStackViewControllers(currentVC: currentController, newVC: vc) {
            vc?.navigationItem.hidesBackButton = true
            vc?.title = "Construction Helper"
            showViewAnimated()
            navController.fadeTo(vc!)
            return
        }
        
        vc?.removeFromParentViewController()
        vc = nil
    }
    
    private func push(vcAsModal vc: UIViewController?) {

        guard let vc = vc else { return }
        
        vc.modalPresentationStyle = .fullScreen
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext

        present(navigationController, animated: false, completion: nil)
    }
    
    private func canStackViewControllers(currentVC: UIViewController?, newVC: UIViewController?) -> Bool {
        
        if currentVC?.classForCoder != newVC?.classForCoder {
            return true
        }
        
        return false
    }
    
    @objc func showViewAsPopover(_ notification: Notification) {
        
        guard let viewController = notification.object as? UIViewController else { return }
        viewController.modalPresentationStyle = .popover
        
        // Determine the top most view controller and present over it
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if topController.classForCoder != viewController.classForCoder {
                topController.present(viewController, animated: true, completion: nil)
            }
            return
        }
        
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func showWarning_(_ notification: NSNotification) {
        guard let message = notification.object as? String else { return }
        showWarningWithMessage(message: message)
    }
    
    @objc func dismissAllPopoverControllers(_ notification: NSNotification? = nil) {
        
        guard let targetVcType = notification?.object as? UIViewController.Type else { return }
        dismissAllPopoverControllers(to: targetVcType)
    }
    
    private func dismissAllPopoverControllers(to targetVcType: UIViewController.Type) {
        
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }

        if coreViewModel.shouldDismissToRoot(rootViewController, targetVcType) {
            rootViewController.dismiss(animated: true, completion: nil)
            return
        }
        
        coreViewModel.dismissToTargetVC(rootViewController, targetVcType)
    }
    
}

//Tab bar operations
extension CoreViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if let index = tabBar.items?.firstIndex(of: item) {
            coreViewModel.didSelect(tabPosition: index, self.contentNavigationController)
        }
        
    }
}

//Tabbar hide show on scroll
extension CoreViewController {
    
    @objc func viewScrolledDown(_ notif: Notification) {
        hideViewAnimated()
    }

    @objc func viewScrolledUp(_ notif: Notification) {
        showViewAnimated()
    }
    
    private func hideViewAnimated() {
        
        if (isAnimatingBottomPanels) { return; }
        
        isAnimatingBottomPanels = true
    
        DispatchQueue.main.async {
        
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .allowUserInteraction, animations: {
                
                self.uiTabBarViewHeightConstraints.constant = 0
                self.uiTabBarHeightConstraints.constant = 0
                self.contentNavigationController.setNavigationBarHidden(true, animated: true)
                
                self.view.layoutIfNeeded()
                self.contentNavigationController.view.layoutIfNeeded()
            }, completion: { [weak self] (finished: Bool) in
                guard let weakSelf = self else { return }
                weakSelf.updateAnimationIndicator()
            })
            
        }
    }
   
    private func showViewAnimated() {

        if (isAnimatingBottomPanels) { return; }
        
        isAnimatingBottomPanels = true
        
        DispatchQueue.main.async {
                
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .allowUserInteraction, animations: {
                
                self.uiTabBarViewHeightConstraints.constant = ViewHeightUtil.getTabBarHeight()
                self.uiTabBarHeightConstraints.constant = ViewHeightUtil.getTabBarHeight()
                self.contentNavigationController.setNavigationBarHidden(false, animated: true)
                
                self.view.layoutIfNeeded()
                self.contentNavigationController.view.layoutIfNeeded()
            }, completion: { [weak self] (finished: Bool) in
                guard let weakSelf = self else { return }
                weakSelf.updateAnimationIndicator()
            })
            
        }
    }
    
    private func updateAnimationIndicator() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            
            guard let weakSelf = self else {return}
            
            weakSelf.isAnimatingBottomPanels = false
        })
    }
    
}

extension CoreViewController {
    
    func showWarningWithMessage(message: String, delay: DispatchTime = DispatchTime(uptimeNanoseconds: 300000)) {
        showWarningViewAnim()
        DispatchQueue.main.asyncAfter(deadline: delay, execute: { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.hideWarningViewAnim()
        })
    }
    
    private func hideWarningView() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {return}
            self?.warningViewHeightConstraints.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
    
    private func hideWarningViewAnim() {
        DispatchQueue.main.async {
                
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .allowUserInteraction, animations: {
                
                self.warningViewHeightConstraints.constant = 0
                
                self.view.layoutIfNeeded()
                self.contentNavigationController.view.layoutIfNeeded()
            }, completion: { [weak self] (finished: Bool) in
                guard let weakSelf = self else { return }

            })
            
        }
    }
    
    private func showWarningViewAnim() {
        DispatchQueue.main.async {
                
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .allowUserInteraction, animations: {
                
                self.warningViewHeightConstraints.constant = ViewHeightUtil.getWarningViewHeight()
                
                self.view.layoutIfNeeded()
                self.contentNavigationController.view.layoutIfNeeded()
            }, completion: { [weak self] (finished: Bool) in
                guard let weakSelf = self else { return }

            })
            
        }
    }
}
