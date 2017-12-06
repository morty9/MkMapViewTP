//
//  MainStoreViewController.swift
//  MkMapViewTP
//
//  Created by Bérangère La Touche on 16/11/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

import UIKit

class MainStoreViewController: UIViewController, StoreProvider {
    
    var stores: [Store] = []

    @IBOutlet weak var childContentView: UIView!
    
    lazy var mapViewController: MapViewController = {
        let mapViewController =  MapViewController()
        mapViewController.storeProvider = self
        return mapViewController
    }()
    
    lazy var listViewController: StoreListViewController = {
        return StoreListViewController()
    }()
    
    public var visibleViewController: UIViewController {
        if self.mapViewController.view.window != nil {
            return self.mapViewController
        }
        return self.listViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(self.mapViewController, in: childContentView)
    }
    
    @IBAction func switchController(_ sender: Any) {
        
        let visibleViewController = self.visibleViewController
        self.removeVisibleChildViewController(visibleViewController)
        if visibleViewController == self.mapViewController {
            UIView.beginAnimations("flip_animation", context: nil)
            UIView.setAnimationTransition(.flipFromRight, for: self.childContentView, cache: false)
            UIView.setAnimationDuration(0.5)
            self.addChildViewController(self.listViewController, in: childContentView)
        } else {
            UIView.beginAnimations("flip_animation", context: nil)
            UIView.setAnimationTransition(.flipFromLeft, for: self.childContentView, cache: false)
            UIView.setAnimationDuration(0.5)
            self.addChildViewController(self.mapViewController, in: childContentView)
        }
        
        UIView.commitAnimations()
    }
    
    @IBAction func touchNewAppleStore(_ sender: Any) {
        let appleStoreViewController = NewAppleStoreViewController()
        appleStoreViewController.delegate = self
        self.present(PortraitNavigationController(rootViewController: appleStoreViewController), animated: true)
    }

}

extension MainStoreViewController: NewAppleStoreViewControllerDelegate {
    
    func newAppleStoreViewController(_ newAppleStoreViewController: NewAppleStoreViewController, didCreateStore store: Store) {
        self.stores.append(store)
        newAppleStoreViewController.dismiss(animated: true)
    }
    
}
