//
//  NewAppleStoreViewController.swift
//  MkMapViewTP
//
//  Created by Bérangère La Touche on 15/11/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

import UIKit
import CoreLocation

public protocol NewAppleStoreViewControllerDelegate: class {
    
    func newAppleStoreViewController(_ newAppleStoreViewController: NewAppleStoreViewController, didCreateStore store: Store)
    
}

public class NewAppleStoreViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var latitudeTextField: UITextField!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var lonLabel: UILabel!
    @IBOutlet weak var lonTextField: UITextField!
    
    public weak var delegate: NewAppleStoreViewControllerDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = NSLocalizedString("controllers.new_apple_store.title", comment: "")
        self.titleLabel.text = NSLocalizedString("controllers.new_apple_store.title_label", comment: "")
        self.latitudeLabel.text = NSLocalizedString("controllers.new_apple_store.title_textFieldLat", comment: "")
        self.lonLabel.text = NSLocalizedString("controllers.new_apple_store.title_textFieldLng", comment: "")
        
        self.titleTextField.delegate = self
        self.latitudeTextField.delegate = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeViewController))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(submitAppleStore))
        
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @objc public func closeViewController() {
        self.dismiss(animated: true)
    }
    
    @objc public func submitAppleStore() {
        guard let title = self.titleTextField.text,
            title.count > 0,
            let latString = self.latitudeTextField.text,
            let lat = Double(latString),
            let lngString = self.lonTextField.text,
            let lng = Double(lngString) else {
                let alert = UIAlertController(title:NSLocalizedString("app.vocabulary.error_title", comment: ""),
                                              message: NSLocalizedString("app.vocabulary.error_form_message", comment: ""),
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("app.vocabulary.close", comment: ""),
                                              style: .cancel))
                self.present(alert, animated: true)
                return
            }
        let store = Store(name: title, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
        self.delegate?.newAppleStoreViewController(self, didCreateStore: store)
    }
    
}

extension NewAppleStoreViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
