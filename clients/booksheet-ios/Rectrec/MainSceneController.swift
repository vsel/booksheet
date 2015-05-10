//
//  MainSceneController.swift
//  Rectrec
//
//  Created by Volodymyr Selyukh on 14.03.15.
//  Copyright (c) 2015 D4F. All rights reserved.
//

import UIKit

class MainSceneController: UIViewController {

    var json : JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        CredentialStore.sharedInstance.setUserCredentials("test@123.ua", password: "1qw2")
        CredentialStore.sharedInstance.isTokenPresent()
        //CredentialStore.sharedInstance.getTokenWithBasicAuth()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
