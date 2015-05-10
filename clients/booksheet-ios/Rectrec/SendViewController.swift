//
//  SendViewController.swift
//  Rectrec
//
//  Created by Volodymyr Selyukh on 03.04.15.
//  Copyright (c) 2015 D4F. All rights reserved.
//

import UIKit

class SendViewController: UIViewController, UITextViewDelegate {
    var test = false
    var text = ""
    
    @IBOutlet weak var recText: UITextField!
    @IBOutlet weak var bookname: UITextField!
    @IBOutlet weak var page: UITextField!
    
    
    @IBAction func sendBookmarkButton(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setObject(bookname.text, forKey: "bookname")
        NSUserDefaults.standardUserDefaults().setObject(page.text, forKey: "page")
        //println(BasicNetworkJSONSender().send(text,page: page.text,bookname: bookname.text))
        let bookmark = Bookmark.initForSend(text,page: page.text,bookname: bookname.text)
        BasicNetworkJSONSender.sendBookmark(bookmark)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let oldBookname: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("bookname") {
            bookname.text = oldBookname as! String
        }
        recText.text = text

    }

}
