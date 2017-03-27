//
//  ViewController.swift
//  Home Finder
//
//  Created by Farshad on 3/26/17.
//  Copyright © 2017 WolfskiN. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var lblLocation: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector:#selector(ViewController.updateUI), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: "lastLocation", options: .new, context: nil)
        
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "lastLocation" {
            updateUI()
        }
    }

    func updateUI() {
        if let location = UserDefaults.standard.value(forKey: "lastLocation") as? String {
            lblLocation.text = location
        } else {
            lblLocation.text = "Not Determined"
        }
    }

}

