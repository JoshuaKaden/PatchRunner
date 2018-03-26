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
    var debugMode: Bool
    
    private var patchesToRun: [Runnable] = []
    
    init(patches: [Runnable], debugMode: Bool = false) {
        self.patches = patches
        self.debugMode = debugMode
        patchesToRun = patches
    }
    
    func run() {
        guard let patch = patchesToRun.filter({ !$0.hasBeenRun() }).first else {
            debugPrint("all patches run")
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        var patchFinished = false
        
        debugPrint("running patch \(patch.runIdentifier)")
        patch.run {
            success in
            self.debugPrint("patch finished with \(success)")
            
            if !success {
                self.debugPrint("skip this patch by removing it from the 'to run' array")
                self.patchesToRun = self.patchesToRun.filter { $0.runIdentifier != patch.runIdentifier }
            }
            
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
        if debugMode {
            print("PatchRunner - \(Date()) - \(message)")
        }
    }
}
