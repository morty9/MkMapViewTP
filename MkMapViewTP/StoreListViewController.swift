//
//  StoreListViewController.swift
//  MkMapViewTP
//
//  Created by Bérangère La Touche on 16/11/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

import UIKit

class StoreListViewController: MyViewController {

    @IBOutlet weak var storeCollectionView: UICollectionView!
    
    weak var storeProvider : StoreProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //peut etre fait dans le xib (drag and drop la collection view sur file's owner)
        self.storeCollectionView.delegate = self
        self.storeCollectionView.dataSource = self
        
        self.storeCollectionView.register(UINib(nibName: "StoreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Store")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.storeCollectionView.reloadData()
    }

}

extension StoreListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.storeProvider?.stores.count ?? 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Store", for: indexPath)
        
        guard let store = self.storeProvider?.stores[indexPath.item] else {
            fatalError("Not possible")
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Store", for: indexPath)
        cell.contentView.backgroundColor = .gray
        
        if let storeCell = cell as? StoreCollectionViewCell {
            storeCell.titleLabel.text = store.name
            storeCell.latLabel.text = String(store.coordinate.latitude)
            storeCell.lonLabel.text = String(store.coordinate.longitude)
        }
        
        return cell
    }
    
}

extension StoreListViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //pour designer une cellule différemment
//        if indexPath.item == 0 {
//            return CGSize(width: 10, height: 10)
//        }
        
        var width = collectionView.bounds.width
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            width -= layout.minimumInteritemSpacing
        }
        return CGSize(width: width / 2, height: width / 2)
    }
    
}

