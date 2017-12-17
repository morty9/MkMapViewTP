//
//  ContextProvider.swift
//  MkMapViewTP
//
//  Created by Bérangère La Touche on 07/12/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

import Foundation
import CoreData

public protocol ContextProvider: class {
    
    var context: NSManagedObjectContext? { get }
    
}

