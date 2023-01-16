//
//  SystemStateController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/10.
//

import Foundation

class SystemState {
    var isOnDragging : Bool = false
    var isTouched : Bool = false
    var isMouseClose : Bool = false
    var isHover : Bool = false
    var touchingTime : Int = 0 // tick count
    
    func resetEveryTick() {
        isTouched = false
    }
    
    func isTouchingTimeInTouchRange() -> Bool {
        return touchingTime < 10
    }
    
    func updateTouchingTime() {
        if touchingTime >= 10 {
            return
        }
        touchingTime += 1
    }
}
