//
//  APIVariablesStoreModel.swift
//  Rectrec
//
//  Created by Volodymyr Selyukh on 04.05.15.
//  Copyright (c) 2015 D4F. All rights reserved.
//

class APIVariablesStore {
    static let sharedInstance = APIVariablesStore()
    
    var mainSite = NSUserDefaults.standardUserDefaults().valueForKey("mainSite") as! String?
    var getToken = "/api/v1.0/token"
    var getBookmarks = "/api/v1.0/bookmarks/get_all"
    var sendBookmark = "/api/v1.0/bookmarks/add"
    
    // METHODS
    init() {
        //println(__FUNCTION__)
        mainSite = "https://obm-vselpublic-1.c9.io"
        getToken = mainSite!+"/api/v1.0/token"
        getBookmarks = mainSite!+"/api/v1.0/bookmarks/get_all"
        sendBookmark = mainSite!+"/api/v1.0/bookmarks/add"
        
    }
}

