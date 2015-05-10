//
//  CredentialStore.swift
//  Rectrec
//
//  Created by Volodymyr Selyukh on 04.05.15.
//  Copyright (c) 2015 D4F. All rights reserved.
//

class CredentialStore {
    static let sharedInstance = CredentialStore()
    
    var userEmale = NSUserDefaults.standardUserDefaults().valueForKey("userEmail") as! String?
    //var password: String?
    var password : String?
    var token = NSUserDefaults.standardUserDefaults().valueForKey("token") as! String?
    var userid = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! String? ?? "2"
    
    // METHODS
    init() {
        //println(__FUNCTION__)
        password = "1qw2"
    }
    
    func setUserCredentials(userEmale: String?, password: String?){
        NSUserDefaults.standardUserDefaults().setObject(userEmale, forKey: "userEmale")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.password = password!
        self.userEmale = userEmale!
    }
    
    func isTokenPresent() -> Bool {
        if token == nil {
            if password == nil {
                return false
            }
            else {
                getTokenWithBasicAuth()
                return true
            }
        }
        else {
            println(self.token)
            return true
        }
    }
    
    func getTokenWithBasicAuth(){
        BasicNetworkJSONSender.sendCredAndGetToken(self.userEmale!, password: self.password!){ (token, error) in
            if token != nil {
                self.token = token!
                NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                NSUserDefaults.standardUserDefaults().synchronize()
                //println(token!+"New")
            } else {
                // Handle error / nil accessKey here
                println("FUCK")
            }
        }
    }
}

