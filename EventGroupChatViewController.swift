//
//  EventChatViewController.swift
//  Primetime
//
//  Created by Philipp Eibl on 7/24/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EventGroupChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func sendButtonTapped(sender: UIButton) {
        if messageTextField.text! != "" {
            sendMessage()
        }
    }
    
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var sendMessageButton: UIButton!
    @IBOutlet var messagesTableView: UITableView!
    
    var ref: FIRDatabaseReference!
    var currentUser: User = ModelHelper.createUser("testuser2@mail.com", name: "test user", password: "pwd")// will be passed with segue
    var eventName = "johnsBBQ" // will be passed with segue
    var messages: [Message] = [] {
        didSet {
            self.messagesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        getMessages()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let message = messages[indexPath.row]
        
        let cell: MessageTableViewCell
        
        if messages[indexPath.row].sender == currentUser.email {
            cell = messagesTableView.dequeueReusableCellWithIdentifier("sentMessagePrototype", forIndexPath: indexPath) as! SentMessageCell
        } else {
            cell = messagesTableView.dequeueReusableCellWithIdentifier("receivedMessagePrototype", forIndexPath: indexPath) as! ReceivedMessageCell
        }
        cell.byUserLabel.text = messages[indexPath.row].sender
        cell.content.text = messages[indexPath.row].content ?? "You have no messages"
        
        return cell as! UITableViewCell
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
}

extension EventGroupChatViewController {
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 60
    }
    
    func sendMessage() {
        
        let content = self.messageTextField.text!
        let timeStamp = NSDate()
        let currentUserEmail = "user@mail.com"
        
        self.ref.child("chats").child(eventName).childByAutoId().setValue(["content": content, "timeStamp": String(timeStamp), "sender": currentUser.email])
        
        self.messageTextField.text = ""
    }
    
    func getMessages() {
        
        ref.child("chats").child(eventName).observeEventType(.Value, withBlock: { (snapshot) in
            // Get user value
            guard let messages = snapshot.value! as? [String: AnyObject] else {
                print("is empty");
                self.messages.append(Message(sender: self.currentUser.email, timeStamp: NSDate(), content: "No messages yet!"));
                return
            }
            
            self.messages = []
            
            for messageDetails in messages {
                let senderVar = messageDetails.1["sender"] as! String
                let tempTimeStampVar = messageDetails.1["timeStamp"] as! String
                let contentVar = messageDetails.1["content"] as! String
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let timeStampVar = formatter.dateFromString(tempTimeStampVar)
                
                let messageVar = Message(sender: senderVar, timeStamp: timeStampVar!, content: contentVar)
                
                self.messages.append(messageVar)
            }
            
            self.messages = self.messages.sort({ $0.timeStamp.compare($1.timeStamp) == NSComparisonResult.OrderedAscending })
            self.messagesTableView.reloadData()
            
            // ...
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}