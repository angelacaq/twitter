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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        tweetTextView.becomeFirstResponder()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
