//
//  AppDelegate.swift
//  IdeaBag
//
//  Created by Adriano Soares on 18/02/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import UIKit
import ReactiveReSwift
import Firebase

let mainStore: Store = Store(
    reducer: mainReducer,
    observable: ObservableProperty(AppState())
)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        APIManager.shared.AnonymousLogin().then { action in
            mainStore.dispatch(action)
            return APIManager.shared.LoadPosts()
        }.then { action in
            mainStore.dispatch(action)
        }.catch { error in
            print(error.localizedDescription)
        }
        
        return true
    }
}
