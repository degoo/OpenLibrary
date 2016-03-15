//
//  ViewController.swift
//  OpenLibrary
//
//  Created by Diego Navarro Tarraga on 14/3/16.
//  Copyright © 2016 Diego Navarro Tarraga. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate {

    @IBOutlet weak var ISBNText: UITextField!
    
    @IBOutlet weak var ISBNData: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ISBNText.delegate = self
        ISBNData.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        doFindISBN(textField.text!)
        self.ISBNText.resignFirstResponder()
        return true
    }
    
    func doFindISBN(AISBN: String) {
        let urlString = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + AISBN
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        let result = { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                let bookText = NSString(data: data!, encoding: NSUTF8StringEncoding)
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.ISBNData.text = bookText! as String
                }
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    let alert = UIAlertController(title: "Error de conexion", message: "No puedo establecer la conexion", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);                     alert.addAction(okAction)
                    self.presentViewController(alert, animated: false, completion: nil)
                }
            }
        
        }
        
        let dt = session.dataTaskWithURL(url!, completionHandler: result)
        dt.resume()
    }
}

