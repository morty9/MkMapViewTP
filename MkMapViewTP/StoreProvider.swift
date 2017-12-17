//
//  StoreProvider.swift
//  MkMapViewTP
//
//  Created by Bérangère La Touche on 16/11/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

import Foundation

public protocol StoreProvider: class {
    
    var stores: [Stores] { get }
    
}
