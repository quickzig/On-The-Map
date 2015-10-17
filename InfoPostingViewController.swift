//
//  InfoPostingViewController.swift
//  On The Map
//
//  Created by Brian Quick on 9/30/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//


import UIKit

class InfoPostingViewController: UIViewController {
    
   
    @IBAction func cancelButtonClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}

