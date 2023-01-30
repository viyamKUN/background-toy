//
//  SystemState.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/31.
//

import Foundation

struct SystemState {
    var characterState: Constant.State.CharacterState
    var doNotDisturb: Bool
    var isOnDragging: Bool = false
    var isTouched: Bool = false
    var isHover: Bool = false
    var touchingTime: Int = 0  // tick count

    func isTouchingTimeInTouchRange() -> Bool {
        return touchingTime < Constant.State.touchThreshold
    }
}
