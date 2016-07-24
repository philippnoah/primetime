//
//  LoginViewController.swift
//  Primetime
//
//  Created by Philipp Eibl on 7/23/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {
    
// OUTLETS
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var gotToSignUpButton: UIButton!
    
// VARIABLES
    var ref = FIRDatabaseReference.init()
    
// FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Logins in the user
    @IBAction func loginAction(sender: AnyObject) {
        
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        if email != "" && password != ""
        {
            // Attemps to log into an existing account
            FIRAuth.auth()?.signInWithEmail(email!, password: password!) { (user, error) in
                
                // Handels the case of an error
                if error == nil
                {
                    NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: "uid")
                    print("Logged in :)")
                    self.performSegueWithIdentifier("fromLoginToHome", sender: self)
                }
                else if (error!.code == 17020) // An error message for no internet connection
                {
                    print("Error Code: \(error!.code)")
                    let alert = UIAlertController(title: "Log in Error", message: "No Internet Connection", preferredStyle:.Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else if (error!.code == 17010) { // An error message for too many requests
                    print(error)
                    print("Error Code: \(error!.code)")
                    let alert = UIAlertController(title: "Too Many Requests", message: "Too Many System Requests. Please try again later", preferredStyle:.Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else if (error!.code == 17009) {  // An error message for the incorrect password
                    print(error)
                    print("Error Code: \(error!.code)")
                    let alert = UIAlertController(title: "Incorrect Password", message: "Please enter the correct password", preferredStyle:.Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else if (error!.code == 17011) {  // An error message for the incorrect email
                    print(error)
                    print("Error Code: \(error!.code)")
                    let alert = UIAlertController(title: "Incorrect Email", message: "Please enter the correct email", preferredStyle:.Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {   // An error message for any other error
                    print(error)
                    print("Error Code: \(error!.code)")
                    let alert = UIAlertController(title: "System Error", message: "Error in the System. Please try again later", preferredStyle:.Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
            
        else // If nothing was input to the text fields, an error message will be returned to the users
        {
            let alert = UIAlertController(title: "Log in Error", message: "Enter Email and Password", preferredStyle:.Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
    }
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}