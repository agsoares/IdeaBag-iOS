//
//  Actions.swift
//  IdeaBag
//
//  Created by Adriano Soares on 18/02/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import Foundation
import ReSwift

struct AnonymousLogin: Action {}
struct LoginFinished: Action {
    var user: AnyObject
}

struct AddIdea: Action {
    var title: String
}

struct LoadIdeas: Action { }
struct LoadIdeasFinished: Action {
    var ideas: Array<NSDictionary>
}


