//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:

            self.openViewControllerBasedOnIdentifier("dashboard")
            
            break
        case 1:
            self.openViewControllerBasedOnIdentifier("messages")
            break
        case 2:
            self.openViewControllerBasedOnIdentifier("updateWeight")
            break
        case 3:
            self.openViewControllerBasedOnIdentifier("changeGoal")
            break
        case 4:
            self.openViewControllerBasedOnIdentifier("switchTeam")
            break
        case 5:
            self.openViewControllerBasedOnIdentifier("team")
            break
        case 6:
            self.openViewControllerBasedOnIdentifier("updateProfile")
            break
        case 7:
            self.openViewControllerBasedOnIdentifier("start")
            Server.sharedInstance.currentUid = ""
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOnIdentifier(strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier(strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButtonType.System)
        btnShowMenu.setImage(self.defaultMenuImage(), forState: UIControlState.Normal)
        btnShowMenu.frame = CGRectMake(0, 0, 22, 22)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }

    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        let radius: CGFloat = 2
    
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(22, 22), false, 0.0)
        
        UIColor.blackColor().setFill()
        UIBezierPath(roundedRect: CGRectMake(0, 4, 22, 2), cornerRadius: radius).fill()
        UIBezierPath(roundedRect: CGRectMake(0, 11, 22, 2), cornerRadius: radius).fill()
        UIBezierPath(roundedRect: CGRectMake(0, 18, 22, 2), cornerRadius: radius).fill()
        
//        UIColor.whiteColor().setFill()
//        UIBezierPath(roundedRect: CGRectMake(0, 4, 24, 1), cornerRadius: radius).fill()
//        UIBezierPath(roundedRect: CGRectMake(0, 11,  24, 1), cornerRadius: radius).fill()
//        UIBezierPath(roundedRect: CGRectMake(0, 18, 24, 1), cornerRadius: radius).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
       
        return defaultMenuImage;
    }
    
    func onSlideMenuButtonPressed(sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.mainScreen().bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clearColor()
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.enabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRectMake(0 - UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            menuVC.view.frame=CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
            sender.enabled = true
            }, completion:nil)
    }
    
    
    
    
}
