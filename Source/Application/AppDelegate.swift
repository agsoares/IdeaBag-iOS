//
//  AppDelegate.swift
//  IdeaBag
//
//  Created by Adriano Soares on 18/02/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import UIKit
import ReSwift
import Firebase

let mainStore = Store<AppState>(
    reducer: MainReducer(),
    state: nil
)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        mainStore.dispatch(AnonymousLogin())
        
        return true
    }
}

