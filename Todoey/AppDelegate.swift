//
//  AppDelegate.swift
//  Todoey
//
//  Created by Hardeep on 16/01/19.
//  Copyright © 2019 Hardeep. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
      //print(Realm.Configuration.defaultConfiguration.fileURL)
        
      
        
        do{
            _ = try Realm()
            
        }catch{
            
            print("error initiallization not done realm\(error)")
        }

        return true
    }


}

