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

class SignUpViewController: UIViewController {
    
// OUTLETS
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var signUpLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordConfrimationTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var goToLoginButton: UIButton!
    
// VARIABLES
    var ref = FIRDatabaseReference.init()
    
// FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        
        // Holds the text of the email and password text fields
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        let username = self.nameTextField.text
        
        let userEmail = email!.componentsSeparatedByString(".")[0]
        
        if email != "" && password != "" && username != ""
        {
            self.ref.child("users").child("\(userEmail)").child("Username").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if (!(snapshot.value is NSNull)) {
                    self.ref.child("users").child("\(userEmail)").child("Username").setValue(username!)
                } else {
                    self.ref.child("users").child("\(userEmail)").child("Username").setValue(username!)
                }
            })
            self.ref.child("users").child("\(userEmail)").child("Email").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if (!(snapshot.value is NSNull)) {
                    self.ref.child("users").child("\(userEmail)").child("Email").setValue(email!)
                } else {
                    self.ref.child("users").child("\(userEmail)").child("Email").setValue(email!)
                }
            })
            
            self.ref.child("users").child("\(userEmail)").child("Password").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if (!(snapshot.value is NSNull)) {
                    self.ref.child("users").child("\(userEmail)").child("Password").setValue(password!)
                } else {
                    self.ref.child("users").child("\(userEmail)").child("Password").setValue(password!)
                }
            })
            
            // Attempts to create a new user
            FIRAuth.auth()?.createUserWithEmail(email!, password: password!) { (user, error) in
                if error == nil
                {
                    NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: "uid")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    print("Account Created :)")
                    
                    // Sets the user's points to 0 when they first create an account
                    
                    self.performSegueWithIdentifier("fromSignupToHome", sender: self)
                } // HANDLE THE ERROR WHEN A NEW USER TRIES TO USE THE SAME EMAIL ADDRESS
                else if (error!.code == 17007) {
                    let alert = UIAlertController(title: "Error", message: "Email already in use", preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    print("print error: \(error) \n")
                }  else {
                    let alert = UIAlertController(title: "Error", message: "Incorret Information.", preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    print("print error: \(error) \n")
                }
            }
        }
        else // If nothing is entered in the email or password fields, an error will be returned to the user
        {
            let alert = UIAlertController(title: "Error", message: "Account creatation information.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
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