//
//  MainReducer.swift
//  IdeaBag
//
//  Created by Adriano Soares on 18/02/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import Foundation
import ReactiveReSwift

let mainReducer: Reducer<AppState> = { action, state -> AppState in
    var state = state

    state = authReducer(action, state)
    state = ideaReducer(action, state)

    return state
}
