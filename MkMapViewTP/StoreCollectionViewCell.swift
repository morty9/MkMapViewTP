//
//  StoreCollectionViewCell.swift
//  MkMapViewTP
//
//  Created by Bérangère La Touche on 06/12/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 3
    }
    
}
