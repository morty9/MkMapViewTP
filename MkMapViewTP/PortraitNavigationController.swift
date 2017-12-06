//
//  PortraitNavigationController.swift
//  MkMapViewTP
//
//  Created by Bérangère La Touche on 15/11/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

import Foundation
import UIKit

public class PortraitNavigationController: UINavigationController {
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.visibleViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
}
