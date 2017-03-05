//
//  ReactiveReSwiftBridge.swift
//  IdeaBag
//
//  Created by Adriano Soares on 04/03/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import ReactiveReSwift
import PromiseKit

extension Promise: StreamType {
    public typealias ValueType = T
    public typealias DisposableType = DisposableFake

    public func subscribe(_ function: @escaping (T) -> Void) -> DisposableFake? {
        _ = self.then(execute: function)
        return nil
    }
}

public struct DisposableFake: SubscriptionReferenceType {
    public func dispose() {}
}
