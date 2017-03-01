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

struct IdeaReducer {
    var database = FIRDatabase.database()

    func reducer() -> Reducer<AppState> {
        return { action, state -> AppState in
            var state = state

            switch action {
            case let action as AddIdea:
                guard let user = state.user else {
                    break
                }
                let idea = ["title": action.title]

                let ref = self.database.reference()
                ref.child("users/\(user.uid)/posts").childByAutoId().setValue(idea)
                state.ideas.append(idea as NSDictionary)
                break

            case _ as LoadIdeas:
                guard let user = state.user else {
                    break
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

                    mainStore.dispatch(LoadIdeasFinished(ideas: ideas))
                })

                break
            case let action as LoadIdeasFinished:
                let ideas = action.ideas
                state.ideas = ideas
                break

            default:
                break
            }

            return state

        }
    }
}
