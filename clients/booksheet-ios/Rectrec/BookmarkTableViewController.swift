//
//  BookmarkTableViewController.swift
//  Rectrec
//
//  Created by Volodymyr Selyukh on 26.04.15.
//  Copyright (c) 2015 D4F. All rights reserved.
//

import UIKit

class BookmarkTableViewController: UITableViewController {
    //Primer ot Andreya pro class DataSources!!!!
    /*
    var bookmarks = [["text" : "iseyJhbGciOiJIUzI1NiIsImV4cCI6MTQzMDQxMTMzOCwiaWF0IjoxNDMwMDUxMzM4fQ.eyJpZCI6Mn0.-8Zshxuwut58k0c9FlkCI9V1SMhx44QkBmBPxQFLxHUiseyJhbGciOiJIUzI1NiIsImV4cCI6MTQzMDQxMTMzOCwiaWF0IjoxNDMwMDUxMzM4fQ.eyJpZCI6Mn0.-8Zshxuwut58k0c9FlkCI9V1SMhx44QkBmBPxQFLxHUiseyJhbGciOiJIUzI1NiIsImV4cCI6MTQzMDQxMTMzOCwiaWF0IjoxNDMwMDUxMzM4fQ.eyJpZCI6Mn0.-8Zshxuwut58k0c9FlkCI9V1SMhx44QkBmBPxQFLxHU",
        "bookname" : "test",
        "timestamp" : "Tue, 07 Apr 2015 10:00:37 GMT",
        "page" : "1"],["text" : "Греховность",
            "bookname" : "test2",
            "timestamp" : "Tue, 08 Apr 2015 10:00:37 GMT",
            "page" : "1"]]
    */
    
    var bookmarks: JSON?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        BasicNetworkJSONSender.reciveAllBookmarksFromAPI2(){ (data, error) in
            if data != nil {
                println(data)
                self.bookmarks = data
                self.tableView.reloadData()
            } else {
                // Handle error / nil accessKey here
                println("FUCK")
            }
        }

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        //println(bookmarks.count)
        //return bookmarks.count
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return bookmarks?.count ?? 0
        //return 1
    }

    let BookmarkReuseIdentifier: String = "Bookmark"

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BookmarkReuseIdentifier, forIndexPath: indexPath) as! BookmarkTableViewCell //as UITableViewCell
        
        // Configure the cell...
        
        var bookmark = Bookmark().initWithJSON(bookmarks![indexPath.row])
        // cell.updateWithBookmark(bookmark)
        cell.bookmark = bookmark
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
