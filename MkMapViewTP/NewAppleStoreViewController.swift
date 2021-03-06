//
//  NewAppleStoreViewController.swift
//  MkMapViewTP
//
//  Created by Bérangère La Touche on 15/11/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

public protocol NewAppleStoreViewControllerDelegate: class {
    
    func newAppleStoreViewController(_ newAppleStoreViewController: NewAppleStoreViewController, didCreateStore store: Stores)
    
}

public class NewAppleStoreViewController: MyViewController {
    
    public var context: NSManagedObjectContext!
    
    public var exist: Bool = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var latitudeTextField: UITextField!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var lonLabel: UILabel!
    @IBOutlet weak var lonTextField: UITextField!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    
    public var name: String!
    public var address : String!
    public var lat : String!
    public var lng : String!
    
    public var location: CLLocation!
    
    public weak var delegate: NewAppleStoreViewControllerDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("controllers.new_apple_store.title", comment: "")
        self.titleLabel.text = NSLocalizedString("controllers.new_apple_store.title_label", comment: "")
        self.latitudeLabel.text = NSLocalizedString("controllers.new_apple_store.title_textFieldLat", comment: "")
        self.lonLabel.text = NSLocalizedString("controllers.new_apple_store.title_textFieldLng", comment: "")
        
        self.titleTextField.delegate = self
        self.latitudeTextField.delegate = self
        
        self.titleTextField.text = name
        self.addressTextField.text = address
        self.lonTextField.text = lng
        self.latitudeTextField.text = lat
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeViewController))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createOrUpdate))
        
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @objc public func closeViewController() {
        self.dismiss(animated: true)
    }
    
    func updateStore() {
        print("UPDATE")
        
        guard
            let title = self.titleTextField.text,
            title.count > 0,
            let latString = self.latitudeTextField.text,
            let lat = Double(latString),
            let lngString = self.lonTextField.text,
            let lng = Double(lngString),
            let address = self.addressTextField.text
            else {
                let alert = UIAlertController(title:NSLocalizedString("app.vocabulary.error_title", comment: ""),
                                              message: NSLocalizedString("app.vocabulary.error_form_message", comment: ""),
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("app.vocabulary.close", comment: ""),
                                              style: .cancel))
                self.present(alert, animated: true)
                return
        }
        
        let request: NSFetchRequest<Stores> = Stores.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", self.name)
        guard let result = try? self.context.fetch(request) else {
            return
        }
        result.forEach {
            $0.name = title
            $0.address = address
            $0.latitude = lat
            $0.longitude = lng
        }
        
        self.dismiss(animated: true, completion: nil)
        try? self.context.save()
        exist = false
    }
    
    @objc public func createOrUpdate() {
        if (exist == true) {
            self.updateStore()
        } else {
            self.createStore()
        }
    }
    
    @objc public func createStore() {
        print("CREATE")
        let store = Stores(context: self.context)
        guard
            let title = self.titleTextField.text,
            title.count > 0,
            let latString = self.latitudeTextField.text,
            let lat = Double(latString),
            let lngString = self.lonTextField.text,
            let lng = Double(lngString),
            let address = self.addressTextField.text
        else {
            let alert = UIAlertController(title:NSLocalizedString("app.vocabulary.error_title", comment: ""),
                                          message: NSLocalizedString("app.vocabulary.error_form_message", comment: ""),
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("app.vocabulary.close", comment: ""),
                                          style: .cancel))
            self.present(alert, animated: true)
            return
        }
        store.name = title
        store.latitude = lat
        store.longitude = lng
        store.address = address
        
        self.delegate?.newAppleStoreViewController(self, didCreateStore: store)
        try? self.context.save()
    }
    
}

extension NewAppleStoreViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
