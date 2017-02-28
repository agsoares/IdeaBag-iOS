//
//  AuthReducerTests.swift
//  IdeaBag
//
//  Created by Adriano Soares on 27/02/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//


@testable import IdeaBag
import XCTest
import ReactiveReSwift

class AuthReducerTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAnonymousLogin() {
        let expectation = self.expectation(description: "AnonymousLoginStarted")
        let initialState = AppState(user: nil, ideas: [])
        
        let testStore = Store (
            reducer: mainReducer,
            observable: ObservableProperty(initialState)
        )
        
        let disposeBag = SubscriptionReferenceBag()
    
        testStore.dispatch(AnonymousLogin())
        
        disposeBag += mainStore.observable.subscribe({ state in
            XCTAssertNotNil(state.user, "User should not be nil")
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)

    }
}
