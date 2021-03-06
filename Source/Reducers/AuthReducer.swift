//
//  AuthReducer.swift
//  IdeaBag
//
//  Created by Adriano Soares on 25/02/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import Foundation

import Foundation
import FirebaseAuth
import ReactiveReSwift

let authReducer: Reducer<AppState> = { (action, state) -> AppState in
    var auth = FIRAuth.auth()
    var state = state

    switch action {
    case _ as AnonymousLogin:
        auth?.signInAnonymously(completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                mainStore.dispatch(LoginFinished(user: user!))
            }
        })
        break

    case let action as LoginFinished:
        state.user = action.user as? FIRUser
        break

    default:
        break
    }

    return state

}
