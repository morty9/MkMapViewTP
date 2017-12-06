//
//  UIViewController+ChildViewController.swift
//  MkMapViewTP
//
//  Created by Bérangère La Touche on 16/11/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

import UIKit

extension UIViewController {
 
    func removeVisibleChildViewController(_ childController: UIViewController) {
        childController.removeFromParentViewController()
        childController.view.removeFromSuperview()
    }
    
    func addChildViewController(_ childController: UIViewController, in subview: UIView) {
        
        guard let view = childController.view else {
            return
        }
        view.frame = subview.bounds
        view.autoresizingMask = UIViewAutoresizing(rawValue: 0b111111)
        // ou view.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth];
        subview.addSubview(view)
        self.addChildViewController(childController)
    }
    
}
