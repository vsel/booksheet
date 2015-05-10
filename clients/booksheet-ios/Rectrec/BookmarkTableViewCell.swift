//
//  BookmarkTableViewCell.swift
//  Rectrec
//
//  Created by Volodymyr Selyukh on 26.04.15.
//  Copyright (c) 2015 D4F. All rights reserved.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell{
    //Poizvonit Andruhe i sdelat tak chtob ne xranitr sostoyqnie
    var bookmark:Bookmark?{
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var bookmarkText: UILabel!
    @IBOutlet weak var bookname: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var page: UILabel!
    
    func updateUI() {
        //reset All
        bookmarkText.text = nil
        bookname.text = nil
        date.text = nil
        page.text = nil
        //Add Bookmark
        if let bookmark = self.bookmark{
            bookmarkText.text = bookmark["bookmarkText"]
            bookname.text = bookmark["bookname"]
            date.text = bookmark["date"]
            page.text = "Page "+bookmark["page"]
        }
    }

}
