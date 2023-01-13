//
//  MovingController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/13.
//

import Foundation
import Cocoa

class MovingController {
    var direction = NSPoint(x: 1, y: 1)
    
    func updatePosition(window: NSWindow?, stateController: StateController) {
        if window === nil {
            return
        }
        let origin = window!.frame.origin
        let originPoint = NSPoint(x: origin.x, y: origin.y)
        var desiredPosition = originPoint
        
        let isWalking = stateController.currentState == .walk
        if isWalking {
            if stateController.isUpdated {
                updateDirection()
            }
            desiredPosition = NSPoint(x: originPoint.x + direction.x,
                                      y: originPoint.y + direction.y)
        }
        
        window!.setFrameOrigin(desiredPosition)
    }
    
    private func updateDirection() {
        // TODO: 걷는 방향을 결정.
        direction = NSPoint(x: 1, y: 1) // sample
    }
}