//
//  BasicNetworkJSONSenderModel.swift
//  Rectrec
//
//  Created by Volodymyr Selyukh on 22.03.15.
//  Copyright (c) 2015 D4F. All rights reserved.
//

import Foundation
import Alamofire

class BasicNetworkJSONSender {
    
    class func reciveAllBookmarksFromAPI2(completionHandler: (JSON?, NSError?) -> ()) -> Void {
        //println("Start!!")
        var dataFromRequest : JSON?
        let token = CredentialStore.sharedInstance.token
        Alamofire.request(.GET, APIVariablesStore.sharedInstance.getBookmarks)
            .authenticate(user: token!, password: "")
            .responseJSON { (request, response, data, error) in
            if let anError = error{
                // got an error in getting the data, need to handle it
                println("error calling GET")
                println(error)
            }
            else if let data: AnyObject = data{
                // handle the results as JSON, without a bunch of nested if loops
                let json = JSON(data)
                dataFromRequest = json.dictionaryValue.values.array[0]
                }
            //VSE IZMENENIYA UI DOLZNY BYT' V MAIN QUEUE
            //dispatch_async(dispatch_get_main_queue()) {
                completionHandler(dataFromRequest, error)
            //}
        }
    }

    class func sendBookmark(bookmark:[String:String]) -> Void{
        //TODO: MAYBE token take here not from NSUserD?
        var usersEndpoint = APIVariablesStore.sharedInstance.sendBookmark
        let userid = CredentialStore.sharedInstance.userid
        let token = CredentialStore.sharedInstance.token
        
        Alamofire.request(.POST, usersEndpoint, parameters: bookmark, encoding: .JSON)
            .authenticate(user: token!, password: "")
            .responseJSON { (request, response, data, error) in
                if let anError = error
                {
                    // got an error in getting the data, need to handle it
                    println("error calling POST on /posts")
                    println(error)
                }
                else if let data: AnyObject = data
                {
                    // handle the results as JSON, without a bunch of nested if loops
                    let post = JSON(data)
                    // to make sure it posted, print the results
                    println("The post is: " + post.description)
                }
        }
    }
    
    class func sendCredAndGetToken(userEmale:String, password:String,completionHandler: (String?, NSError?) -> ()) -> Void{
            var usersEndpoint = APIVariablesStore.sharedInstance.getToken
            Alamofire.request(.GET, usersEndpoint)
                .authenticate(user: userEmale, password: password)
                .responseJSON { (request, response, data, error) in
                    if let anError = error
                    {
                        // got an error in getting the data, need to handle it
                        println("error calling POST on /token")
                        println(error)
                    }
                    else if let data: AnyObject = data{
                            println("Fuck YEAH")
                    }
            completionHandler(JSON(data!).dictionaryValue.values.array[0].stringValue, error)
        }
    }

}