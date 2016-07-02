//
//  WebViewController.swift
//  twitter
//
//  Created by Angela Chen on 7/1/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var URL: NSURL?
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let requestObj = NSURLRequest(URL: URL!);
        webView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
