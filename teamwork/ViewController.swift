//
//  ViewController.swift
//  teamwork
//
//  Created by Austin Bagley on 2/2/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class ViewController: UIViewController {

    // MARK: Properties
    
    var ref = Firebase(url: "https://radiant-fire-3697.firebaseio.com/")
    
    @IBOutlet weak var currentWeather: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref.observeEventType(.Value, withBlock: {
           snapshot in
           self.currentWeather.text = snapshot.value as? String
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func weatherButton(sender: UIButton) {
        ref.setValue(sender.titleLabel?.text)
    }
    
    

}

