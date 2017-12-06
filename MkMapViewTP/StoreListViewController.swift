//
//  StoreListViewController.swift
//  MkMapViewTP
//
//  Created by Bérangère La Touche on 16/11/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

import UIKit

class StoreListViewController: UIViewController {

    @IBOutlet weak var storeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //peut etre fait dans le xib (drag and drop la collection view sur file's owner)
        self.storeCollectionView.delegate = self
        self.storeCollectionView.dataSource = self
        
        self.storeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "AZERTYUIOP")
    }

}

extension StoreListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AZERTYUIOP", for: indexPath)
        cell.contentView.backgroundColor = .red
        
        return cell
    }
    
}

extension StoreListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            width -= layout.minimumInteritemSpacing
        }
        return CGSize(width: width / 2, height: width / 2)
    }
    
}

