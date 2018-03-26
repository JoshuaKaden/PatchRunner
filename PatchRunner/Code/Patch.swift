//
//  Patch.swift
//  PatchRunner
//
//  Created by Kaden, Joshua on 3/26/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import Foundation

typealias BooleanCompletion = (Bool) -> Void

protocol Runnable {
    var hasBeenRun: () -> Bool { get set }
    var run: (@escaping BooleanCompletion) -> Void { get }
    var runIdentifier: String { get }
}

class Patch: Runnable {
    var hasBeenRun: () -> Bool
    let run: (@escaping BooleanCompletion) -> Void
    let runIdentifier: String
    
    init(hasBeenRun: @escaping () -> Bool, run: @escaping (@escaping BooleanCompletion) -> Void) {
        self.hasBeenRun = hasBeenRun
        self.run = run
        runIdentifier = UUID().uuidString
    }
}
