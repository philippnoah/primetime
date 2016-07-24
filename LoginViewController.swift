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
    var ref: FIRDatabaseReference!
    var email: String!
    var password: String!
    var listOfUsers: [User] = []
    
// FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        setUpVariables()
        getUsers()
    }
    
    func setUpVariables() {
        // connecting the var names to the information of the user
        self.email = emailTextField.text!
        self.password = passwordTextField.text!
        
    }
    
    func getUsers() {
        
        // retrieve all users to authorize the new user
        ref.child("users").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            // create a dictionary of the query result
            let dbEntry = snapshot.value! as! [String: AnyObject]
            
            //loop through all user info details
            for userInformation in dbEntry {
                
                // store userinfo in temporary var's
                let emailVar = userInformation.1["email"] as! String
                let nameVar = userInformation.1["name"] as! String
                let passwordVar = userInformation.1["password"] as! String
                
                // create User instance and add it to the list of users
                let userVar = ModelHelper.createUser(emailVar, name: nameVar, password: passwordVar)
                self.listOfUsers.append(userVar)
                
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if identifier == "login" {
            
            if validateLoginInformation() {
                
                // if login button was pressed/segue was triggered, do this:
                login()
                return true
                
            } else {
                
                // sth went wrong
                print("Create Alert")
            }
            
        } else if identifier == "goToSignUp" {
            
            // if goToLogin button was pressed, do this:
            return true
        }
        
        return false
    }
    
    func validateLoginInformation() -> Bool {
        
        // extract emails from users
        let listOfUserEmails = getUserEmailsFromListOfUsers()
        // get all duplicate emails
        let duplicateUserNames = listOfUserEmails.filter { $0 == email }
        // if there are no users with the same email, password and passwordConfirmation are the same and email is valid, return true
        if duplicateUserNames.count == 0 && isValidEmail(email) {
            return true
        }
        
        return false
    }
    
    func getUserEmailsFromListOfUsers() -> [String] {
        
        var listOfUserEmails: [String] = []
        // loop through user and append email array everytime
        for userObject in self.listOfUsers {
            listOfUserEmails.append(userObject.email)
        }
        // return
        return listOfUserEmails
    }
    
    func isValidEmail(testStr: String) -> Bool {
        // check if email is valid
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func login() {
        // if segue was fired and validation succeeded, add the user to the database
        print("should store logged in user locally")
    }
}