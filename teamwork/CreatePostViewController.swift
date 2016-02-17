//
//  CreatePostViewController.swift
//  teamwork
//
//  Created by Austin Bagley on 2/10/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import UIKit


public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }



class CreatePostViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK : Properties
    
    let update = UpdateData()
    let posts = Posts.sharedInstance
    
    
    // MARK : Constants
    
    let SEGUE_SAVE_POST = "savePost"
    let MESSAGES_CELL_IDENTIFIER = "messageCell"
    
    // MARK : View Controller Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        postSize()
        
        update.updatePosts() {
            self.updateUI()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.registerNib(UINib(nibName: "CustomMessageCell", bundle: nil), forCellReuseIdentifier: MESSAGES_CELL_IDENTIFIER)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        
        
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    // MARK : Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postMessage: UIBarButtonItem!
    
    // MARK : Actions
    
    func postSize() {
        let screenSize:CGRect = UIScreen.mainScreen().bounds
        postMessage.width = screenSize.width - 80
    }
    
    func convertDateTimetoTime(dateTime: NSDate) -> String {
        let dateTime = dateTime
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        let timeString = dateFormatter.stringFromDate(dateTime)
        
        return timeString
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height
            self.tableViewBottomConstraint.constant = keyboardFrame.size.height + 44
            
            if self.posts.posts.count > 0 {
                let row = self.posts.posts.count - Int(1)
                let index = NSIndexPath(forRow: row, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
            
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
//        let info = notification.userInfo!
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 0
            self.tableViewBottomConstraint.constant = 44
        })
    }
    
    @IBAction func savePost(sender: UIBarButtonItem) {
        let post = postMessage.customView as! UITextField
        let text = post.text!
        
        update.createPost(text) {
//            self.performSegueWithIdentifier(self.SEGUE_SAVE_POST, sender: self)
            post.text = ""
            post.resignFirstResponder()
            self.updateUI()
        }
        
    }
    
    func updateUI() {
        configureTableView()
        sortList()

        if posts.posts.count > 0 {
            let row = self.posts.posts.count - Int(1)
            let index = NSIndexPath(forRow: row, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
        
        tableView.reloadData()
        tableView.setNeedsLayout()
        tableView.setNeedsDisplay()
        
    }
    
    func sortList() { // should probably be called sort and not filter
        posts.posts.sortInPlace() { $0.dateTime < $1.dateTime } // sort the fruit by name
        tableView.reloadData(); // notify the table view the data has changed
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK : Table View Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = posts.posts.count
        return rows
    }
    
    
 
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(MESSAGES_CELL_IDENTIFIER, forIndexPath: indexPath) as! CustomMessageCellView
        
        let time = convertDateTimetoTime(posts.posts[indexPath.row].dateTime!)
        
        if posts.posts[indexPath.row].user!.firstName! == CurrentUser.sharedInstance.user!.firstName! {
            cell.userName.textColor = c1
        } else {
            cell.userName.textColor = c3
        }
    
        cell.userName.text = posts.posts[indexPath.row].user!.firstName!
        cell.dateTime.text = time
        cell.messageContent.text = posts.posts[indexPath.row].postContent!
        
        return cell

        
    }
    
    
    
}
