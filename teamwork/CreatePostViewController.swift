//
//  CreatePostViewController.swift
//  teamwork
//
//  Created by Austin Bagley on 2/10/16.
//  Copyright © 2016 Austin Bagley. All rights reserved.
//

import UIKit

    // MARK: Date Helpers

    public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
        return lhs === rhs || lhs.compare(rhs) == .OrderedSame
    }

    public func <(lhs: NSDate, rhs: NSDate) -> Bool {
        return lhs.compare(rhs) == .OrderedAscending
    }

    extension NSDate: Comparable { }



class CreatePostViewController: BaseViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: Properties
    
    let server = Server.sharedInstance
    
    var uid: String?
    var currentUserFirstName: String?
    var currentUserLastName: String?
    var teamId: String?
    var post: UITextField?
    var posts = [Post]()
    var isRegisteredToDataModel = false

    
    // MARK: Constants
    
    let SEGUE_SAVE_POST = "savePost"
    let MESSAGES_CELL_IDENTIFIER = "messageCell"
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postMessage: UIBarButtonItem!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!

    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
        self.post = postMessage.customView as? UITextField
        postSize()
        tableView.registerNib(UINib(nibName: "CustomMessageCell", bundle: nil), forCellReuseIdentifier: MESSAGES_CELL_IDENTIFIER)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreatePostViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreatePostViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        self.getPosts()
        addSlideMenuButton()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.getPosts()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    // MARK: Posts
    
    @IBAction func savePost(sender: UIBarButtonItem) {
        let text = post!.text!
        
        server.createPostForCurrentUser(text) { (success, message) in
            if success {
                self.onSuccessfulPost()
                self.getPosts()
            } else {
                print(message)
            }
        }
    }
    
    func getPosts() {
     
            self.server.getPostsForCurrentTeam() { (success, message, posts) in
                if success {
                    self.posts = posts!
                    self.onSuccessfulGetPost()
                } else {
                    print(message)
                }
            }
        
    }
    
    func onSuccessfulPost() {
        self.post!.text = ""
        self.post!.resignFirstResponder()
    }
    
    func onSuccessfulGetPost() {
        updateUI()
    }
    
    func updateUI() {
        configureTableView()
        sortList()
    
        if posts.count > 0 {
            let row = self.posts.count - Int(1)
            let index = NSIndexPath(forRow: row, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
        
        tableView.reloadData()
        tableView.setNeedsLayout()
        tableView.setNeedsDisplay()
    }
    
    // MARK: Helpers
    
    
    func loadUser() {
        server.getCurrentUser() { (success, message, user) in
            if success {
                self.uid = user!.uid!
                self.currentUserFirstName = user!.firstName!
                self.currentUserLastName = user!.lastName!
            } else {
                self.onError(message)
            }
        }
    }
    
    func onError(message: String?) {
        print(message)
    }
    
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
            
            if self.posts.count > 0 {
                let row = self.posts.count - Int(1)
                let index = NSIndexPath(forRow: row, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
            
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 0
            self.tableViewBottomConstraint.constant = 44
        })
    }
    
    
    func sortList() { // should probably be called sort and not filter
        posts.sortInPlace() { $0.dateTime < $1.dateTime } // sort the fruit by name
        tableView.reloadData(); // notify the table view the data has changed
    }
    
    
    // MARK : Table View Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(MESSAGES_CELL_IDENTIFIER, forIndexPath: indexPath) as! CustomMessageCellView
        
        let time = convertDateTimetoTime(posts[indexPath.row].dateTime!)
        
//        if posts.posts[indexPath.row].firstName! == CurrentUser.sharedInstance.user!.firstName! {
//            cell.userName.textColor = c1
//        } else {
//            cell.userName.textColor = c3
//        }
    
        cell.userName.text = posts[indexPath.row].firstName!
        cell.dateTime.text = time
        cell.messageContent.text = posts[indexPath.row].postContent!
        return cell
    }
    
    
    
}
