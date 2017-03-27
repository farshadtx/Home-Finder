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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector:#selector(ViewController.updateUI), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateUI() {
        if let location = UserDefaults.standard.value(forKey: "lastLocation") as? String {
            lblLocation.text = location
        } else {
            lblLocation.text = "Not Determined"
        }
    }

}

