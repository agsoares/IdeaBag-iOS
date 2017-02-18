//
//  MainReducer.swift
//  IdeaBag
//
//  Created by Adriano Soares on 18/02/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import ReSwift

struct MainReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        var state = state ?? AppState()
        
        switch action {
        case _ as AnonymousLogin:
            FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
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
            
        case let action as AddIdea:
            let idea = ["title": action.title]
            
            let ref = FIRDatabase.database().reference()
            ref.child("users/\(state.user!.uid)/posts").childByAutoId().setValue(idea)
            state.ideas.append(idea as NSDictionary)
            break
        
        case _ as LoadIdeas:
            let ref = FIRDatabase.database().reference().child("users/\(state.user!.uid)/posts")
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
    
}
