//
//  AppState.swift
//  IdeaBag
//
//  Created by Adriano Soares on 18/02/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import Foundation
import ReSwift
import FirebaseAuth

struct AppState: StateType {
    var user: FIRUser? = FIRAuth.auth()?.currentUser
    var ideas = Array<NSDictionary>()
}
