//
//  StoreListViewController.swift
//  MkMapViewTP
//
//  Created by Bérangère La Touche on 16/11/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

import UIKit
import CoreData

class StoreListViewController: MyViewController {

    @IBOutlet weak var storeCollectionView: UICollectionView!
    
    public var context: NSManagedObjectContext!
    var stores = [Stores?]()
    weak var storeProvider : StoreProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //peut etre fait dans le xib (drag and drop la collection view sur file's owner)
        self.storeCollectionView.delegate = self
        self.storeCollectionView.dataSource = self
        
        self.storeCollectionView.register(UINib(nibName: "StoreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Store")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("RELOAD")
        super.viewWillAppear(animated)
        self.stores.removeAll()
        self.fetchRequest()
        self.storeCollectionView.reloadData()
    }

}

extension StoreListViewController {
    
    fileprivate func fetchRequest() {
        let request: NSFetchRequest<Stores> = Stores.fetchRequest()
        guard let result = try? self.context.fetch(request) else {
            return
        }
        result.forEach { self.stores.append( $0 ) }
    }
    
}

extension StoreListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        guard let store = self.stores[indexPath.item] else {
            fatalError("Not possible")
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Store", for: indexPath)
        cell.contentView.backgroundColor = UIColor(red:0.91, green:0.89, blue:0.87, alpha:1.0)
        
        if let storeCell = cell as? StoreCollectionViewCell {
            let bgImageDelete = UIImage(named: "rubbish-bin")
            let buttonDelete = UIButton(frame: CGRect(x: storeCell.frame.width - 40, y: storeCell.frame.height - 180, width: 20, height: 20))
            buttonDelete.setBackgroundImage(bgImageDelete, for: .normal)
            buttonDelete.tag = indexPath.row
            buttonDelete.addTarget(self, action: #selector(deleteStore), for: .touchUpInside)
            storeCell.addSubview(buttonDelete)
            
            let bgImageUpdate = UIImage(named: "update-arrow")
            let buttonUpdate = UIButton(frame: CGRect(x: storeCell.frame.width - 80, y: storeCell.frame.height - 180, width: 20, height: 20))
            buttonUpdate.setBackgroundImage(bgImageUpdate, for: .normal)
            buttonUpdate.tag = indexPath.row
            buttonUpdate.addTarget(self, action: #selector(updateStore), for: .touchUpInside)
            storeCell.addSubview(buttonUpdate)
            
            storeCell.titleLabel.text = store.name
            storeCell.address.text = store.address
            storeCell.latLabel.text = String(store.latitude)
            storeCell.lonLabel.text = String(store.longitude)
            storeCell.context = self.context
        }
        
        return cell
    }
    
    @objc func updateStore(sender : UIButton) {
        let data = self.stores[sender.tag]
        
        let newAppleStoreViewController = NewAppleStoreViewController()
        newAppleStoreViewController.delegate = self
        newAppleStoreViewController.name = data?.name
        newAppleStoreViewController.address = data?.address
        newAppleStoreViewController.lat = String(format:"%f", (data?.latitude)!)
        newAppleStoreViewController.lng = String(format:"%f", (data?.longitude)!)
        newAppleStoreViewController.exist = true
        newAppleStoreViewController.context = self.context
        
        self.dismiss(animated: true, completion: nil)
        self.present(PortraitNavigationController(rootViewController: newAppleStoreViewController), animated: true)
    }
    
    @objc func deleteStore(sender : UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let data = self.stores[sender.tag]
        
        let request: NSFetchRequest<Stores> = Stores.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", (data?.name)!)
        guard let result = try? self.context.fetch(request) else {
            return
        }
        result.forEach { self.context.delete($0) }
        try? self.context.save()
        self.stores.remove(at: sender.tag)
        self.storeCollectionView.deleteItems(at: [indexPath])
        self.storeCollectionView.reloadData()
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

extension StoreListViewController: NewAppleStoreViewControllerDelegate {
    
    func newAppleStoreViewController(_ newAppleStoreViewController: NewAppleStoreViewController, didCreateStore store: Stores) {
        newAppleStoreViewController.dismiss(animated: true)
    }
    
}


