//
//  CreatePostViewController.swift
//  teamwork
//
//  Created by Austin Bagley on 2/10/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController, UITextFieldDelegate {
    
    
    // MARK : Properties
    
    let update = UpdateData()
    
    
    // MARK : Constants
    
    let SEGUE_SAVE_POST = "savePost"
    
    // MARK : View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK : Outlets
    
    @IBOutlet weak var postContent: UITextView!
    
    
    // MARK : Actions
    
    @IBAction func savePost(sender: UIBarButtonItem) {
        
        update.createPost(postContent.text) {
            self.performSegueWithIdentifier(self.SEGUE_SAVE_POST, sender: self)
            
        }
        
    }
    
    
}
