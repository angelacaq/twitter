//
//  ComposeViewController.swift
//  twitter
//
//  Created by Angela Chen on 6/29/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var wordcountLabel: UILabel!
    @IBOutlet weak var buttonBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    var originalHeight: CGFloat!
    var originalLandscapeHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalHeight = self.view.frame.height
        originalLandscapeHeight = self.view.frame.width
        tweetTextView.delegate = self
        
        setupKeyboardObservers()
    }
    
    var isKeyboardShown = false
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.utf16.count + text.utf16.count - range.length

        wordcountLabel.text =  String(140 - newLength)
        return newLength < 140 // To just allow up to 140 characters
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
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        print("HIII")
     }
    
    
}
