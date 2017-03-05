//
//  IdeaReducer.swift
//  IdeaBag
//
//  Created by Adriano Soares on 25/02/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import Foundation

import Foundation
import FirebaseDatabase
import ReactiveReSwift

let ideaReducer: Reducer<AppState> = { action, state -> AppState in
    var state = state

    switch action {
    case let action as LoadIdeasFinished:
        let ideas = action.ideas
        state.ideas = ideas
        break

    default:
        break
    }

    return state
}
