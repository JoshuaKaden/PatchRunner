//
//  PatchRunnerTests.swift
//  PatchRunnerTests
//
//  Created by Kaden, Joshua on 3/26/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import XCTest
@testable import PatchRunner

class PatchRunnerTests: XCTestCase {
    
    var tracker: [String : Bool] = [:]

    override func setUp() {
        super.setUp()
        tracker = [:]
    }
    
    override func tearDown() {
        tracker = [:]
        super.tearDown()
    }
    
    func testTwoPatchesInOrder() {
        let patch1Key = "patch1"
        let patch2Key = "patch2"
        
        let patch1Action: (@escaping BooleanCompletion) -> Void = {
            completion in
            sleep(1)
            self.tracker[patch1Key] = true
            XCTAssertFalse(self.tracker[patch2Key] ?? false)
            completion(true)
        }
        let patch1 = Patch(hasBeenRun: { return self.tracker[patch1Key] ?? false }, run: patch1Action)
        
        let patch2Action: (@escaping BooleanCompletion) -> Void = {
            completion in
            sleep(2)
            self.tracker[patch2Key] = true
            XCTAssertTrue(self.tracker[patch1Key] ?? false)
            completion(true)
        }
        let patch2 = Patch(hasBeenRun: { return self.tracker[patch2Key] ?? false }, run: patch2Action)

        let patches = [patch1, patch2]
        let runner = PatchRunner(patches: patches)
        runner.run()
        
        XCTAssertTrue(tracker[patch1Key] ?? false)
        XCTAssertTrue(tracker[patch2Key] ?? false)
    }
    
    func testTwoAsyncPatchesInOrder() {
        let patch1Key = "patch1"
        let patch2Key = "patch2"

        let patch1Action: (@escaping BooleanCompletion) -> Void = {
            completion in
            DispatchQueue(label: "queue1").async {
                sleep(1)
                self.tracker[patch1Key] = true
                XCTAssertFalse(self.tracker[patch2Key] ?? false)
                completion(true)
            }
        }
        let patch1 = Patch(hasBeenRun: { return self.tracker[patch1Key] ?? false }, run: patch1Action)
        
        let patch2Action: (@escaping BooleanCompletion) -> Void = {
            completion in
            DispatchQueue(label: "queue1").async {
                sleep(2)
                self.tracker[patch2Key] = true
                XCTAssertTrue(self.tracker[patch1Key] ?? false)
                completion(true)
            }
        }
        let patch2 = Patch(hasBeenRun: { return self.tracker[patch2Key] ?? false }, run: patch2Action)
        
        let patches = [patch1, patch2]
        let runner = PatchRunner(patches: patches)
        runner.run()
        
        XCTAssertTrue(tracker[patch1Key] ?? false)
        XCTAssertTrue(tracker[patch2Key] ?? false)
    }

}
