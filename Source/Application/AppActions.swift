//
//  AppActions.swift
//  IdeaBag
//
//  Created by Adriano Soares on 18/02/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import Foundation
import ReactiveReSwift

struct LoginFinished: Action {
    var user: AnyObject
}

struct AddIdeaFinished: Action {
    var idea: NSDictionary?
}

struct LoadIdeasFinished: Action {
    var ideas: [NSDictionary]
}
