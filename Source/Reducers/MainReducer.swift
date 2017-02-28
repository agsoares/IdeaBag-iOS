//
//  MainReducer.swift
//  IdeaBag
//
//  Created by Adriano Soares on 18/02/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import Foundation
import ReactiveReSwift

struct MainReducer {
    var authReducer = AuthReducer()
    var ideaReducer = IdeaReducer()

    func reducer() -> Reducer<AppState> {
        return { action, state -> AppState in
            var state = state

            state = self.authReducer.reducer()(action, state)
            state = self.ideaReducer.reducer()(action, state)

            return state
        }
    }

}
