//
//  APIManager.swift
//  IdeaBag
//
//  Created by Adriano Soares on 04/03/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import Foundation
import ReactiveReSwift
import PromiseKit
import Firebase

class APIManager {
    var auth     = FIRAuth.auth()
    var database = FIRDatabase.database()

    static let shared = APIManager()

    func AnonymousLogin() -> Promise<Action> {
        return PromiseKit.wrap { self.auth?.signInAnonymously(completion:$0) }.then { user in
            return Promise { fulfill, _ in
                fulfill(LoginFinished(user: user))
            }
        }
    }

    func LoadPosts()  -> Promise<Action> {
        let state = mainStore.observable.value

        return Promise { fulfill, _ in
            guard let user = state.user else {
                return
            }
            let ref = self.database.reference().child("users/\(user.uid)/posts")
            ref.keepSynced(true)
            ref.observeSingleEvent(of: .value, with: { snapshot in
                var ideas = [NSDictionary]()
                for child in snapshot.children {

                    let childSnapshot = snapshot.childSnapshot(forPath: (child as AnyObject).key)
                    if let idea = childSnapshot.value as? NSMutableDictionary {
                        idea["id"] = childSnapshot.key
                        ideas.append(idea)
                    }
                }

                fulfill(LoadIdeasFinished(ideas: ideas))
            })
        }
    }

    func AddIdea (title: String) -> Promise<Action> {
        let state = mainStore.observable.value
        return Promise { fulfill, _ in
            guard let user = state.user else {
                return
            }
            let idea = ["title": title]

            let ref = self.database.reference()
            ref.child("users/\(user.uid)/posts").childByAutoId().setValue(idea)
            fulfill(AddIdeaFinished(idea:idea as NSDictionary?))
        }
    }

}
