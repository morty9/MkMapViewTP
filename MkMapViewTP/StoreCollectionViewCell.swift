//
//  StoreCollectionViewCell.swift
//  MkMapViewTP
//
//  Created by Bérangère La Touche on 06/12/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

import UIKit
import CoreData

class StoreCollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    @IBOutlet weak var address: UILabel!
    
    public var storeCollectionView: StoreListViewController!
    
    public var context: NSManagedObjectContext!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 3
    }
    
}
