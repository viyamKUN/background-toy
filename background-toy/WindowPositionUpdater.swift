//
//  MovingController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/13.
//

import Cocoa
import Foundation

class WindowPositionUpdater {
    private var direction = NSPoint(x: 1, y: 1)

    func isFlipped() -> Bool {
        return direction.x > 0
    }

    func updatePosition(window: NSWindow, isStateUpdated: Bool) {
        let origin = window.frame.origin
        let originPoint = NSPoint(x: origin.x, y: origin.y)
        var desiredPosition = originPoint

        if isStateUpdated {
            updateDirection()
        }
        desiredPosition = NSPoint(
            x: originPoint.x + direction.x,
            y: originPoint.y + direction.y)

        window.setFrameOrigin(desiredPosition)
    }

    // Decide randomic direction to walk
    private func updateDirection() {
        var x = Int.random(in: -1...1)
        var y = Int.random(in: -1...1)
        if x == 0 && y == 0 {
            if Bool.random() {
                x = Bool.random() ? -1 : 1
            } else {
                y = Bool.random() ? -1 : 1
            }
        }
        direction = NSPoint(x: x, y: y)
    }
}
