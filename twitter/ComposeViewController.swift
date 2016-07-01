//
//  ComposeViewController.swift
//  twitter
//
//  Created by Angela Chen on 6/29/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var wordcountLabel: UILabel!
    @IBOutlet weak var buttonBottomLayoutConstraint: NSLayoutConstraint!
    
    var originalHeight: CGFloat!
    var originalLandscapeHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.Portrait { print("huh") }
        
        originalHeight = self.view.frame.height
        originalLandscapeHeight = self.view.frame.width
        
        setupKeyboardObservers()
    }
    
    var isKeyboardShown = false
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setupKeyboardObservers() {
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification: NSNotification) in
            if self.isKeyboardShown {
                self.buttonBottomLayoutConstraint.constant = 0
                self.view.layoutIfNeeded()
                self.isKeyboardShown = false
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification: NSNotification) in
            if !self.isKeyboardShown {
                let userInfo = notification.userInfo
                let keyboardFrame = userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue()
                let keyboardHeight = keyboardFrame.size.height
                self.buttonBottomLayoutConstraint.constant = keyboardHeight
                self.view.layoutIfNeeded()
                self.isKeyboardShown = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onXButtonPressed(sender: AnyObject) {
        tweetTextView.text = ""
        tweetTextView.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweetButtonPressed(sender: AnyObject) {
        TwitterClient.sharedInstance.tweet(tweetTextView.text, success: {
            self.tweetTextView.endEditing(true)
            self.dismissViewControllerAnimated(true, completion: nil)
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
    }
    
    /*func keyboardWillShow(notification: NSNotification) {
        if UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.Portrait {
            print("yay")
            if view.frame.height == originalHeight {
                print("yay2")
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                    print("yy3")
                    view.frame = CGRectMake(0 , 0, self.view.frame.width, originalHeight - keyboardSize.height)
                }
            }
        } else {
            if view.frame.height == originalLandscapeHeight {
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                    view.frame = CGRectMake(0 , 0, self.view.frame.width, originalLandscapeHeight - keyboardSize.height)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.Portrait {
            if view.frame.height != originalHeight {
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                    view.frame = CGRectMake(0 , 0, self.view.frame.width, originalHeight + keyboardSize.height)
                }
            }
        } else {
            if view.frame.height != originalLandscapeHeight {
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                    view.frame = CGRectMake(0 , 0, self.view.frame.width, originalLandscapeHeight + keyboardSize.height)
                    
                }
            }
        }
    }*/
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
