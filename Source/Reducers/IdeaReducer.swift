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

let ideaReducer : Reducer<AppState> = { action, state -> AppState in
    var database = FIRDatabase.database()
    var state = state 
    
    switch action {
    case let action as AddIdea:
        guard let user = state.user else {
            break
        }
        let idea = ["title": action.title]
        
        let ref = database.reference()
        ref.child("users/\(user.uid)/posts").childByAutoId().setValue(idea)
        state.ideas.append(idea as NSDictionary)
        break
        
    case _ as LoadIdeas:
        guard let user = state.user else {
            break
        }
        let ref = database.reference().child("users/\(user.uid)/posts")
        ref.keepSynced(true)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var ideas = Array<NSDictionary>()
            for child in snapshot.children {
                
                let childSnapshot = snapshot.childSnapshot(forPath: (child as AnyObject).key)
                let idea = childSnapshot.value
                ideas.append(idea as! NSDictionary)
            }
            
            mainStore.dispatch(LoadIdeasFinished(ideas: ideas))
        });
        
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
