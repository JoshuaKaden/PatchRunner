//
//  PatchRunner.swift
//  PatchRunner
//
//  Created by Kaden, Joshua on 3/26/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import Foundation

class PatchRunner {
    let patches: [Runnable]
    
    init(patches: [Runnable]) {
        self.patches = patches
    }
    
    func run() {
        guard let patch = patches.filter({ !$0.hasBeenRun() }).first else {
            debugPrint("all patches run")
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        var patchFinished = false
        
        debugPrint("running patch")
        patch.run {
            success in
            self.debugPrint("patch finished with \(success)")
            patchFinished = true
            semaphore.signal()
        }
        
        if patchFinished {
            debugPrint("patch finished quickly")
        } else {
            debugPrint("waiting for patch to finish")
            semaphore.wait()
            debugPrint("done waiting")
        }
        
        debugPrint("recursing")
        self.run()
    }
    
    private func debugPrint(_ message: String) {
        print("PatchRunner - \(Date()) - \(message)")
    }
}
