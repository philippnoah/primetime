//
//  DetailEventViewController.swift
//  PrimeTime
//
//  Created by Sudikoff Lab iMac on 7/24/16.
//  Copyright © 2016 PrimeTime. All rights reserved.
//

import UIKit

class DetailEventViewController: UIViewController {

    var newIdString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Helper function to get the title to print out
    func assignIdString(idString: String) {
        newIdString = idString
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
