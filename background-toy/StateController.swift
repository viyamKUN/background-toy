//
//  StateController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/09.
//

import Foundation

class StateController {
    enum CharacterState : String {
        case idle, walk, grab, touch, playingcursor
    }
    var currentState: CharacterState = .idle
    var isUpdated: Bool = true
    var timer: Int = 0 // tick count
    var isTimerOn: Bool = false
    let stateTimer: [CharacterState: Int] = [
        .touch: 5
    ]

    func updateState(systemState : SystemState) {
        // Check exist timer status.
        if self.isTimerOn{
            if self.timer > 0 {
                // Timer is running... Do not update state.
                self.timer -= 1
                return
            }
            else {
                self.turnOffTimer()
            }
        }

        // Update states by system.
        if systemState.isOnDragging {
            self.currentState = .grab
        }
        else if systemState.isTouched {
            self.currentState = .touch
            self.setTimer(time: stateTimer[.touch] ?? 0)
        }
        else if systemState.isMouseClose {
            self.currentState = .playingcursor
        }
        else {
            self.currentState = .idle
        }
    }
    
    func turnOffTimer() {
        self.timer = 0
        self.isTimerOn = false
    }
    
    func setTimer(time: Int) {
        self.isTimerOn = true
        self.timer = time
    }
    
    func resetEveryTick() {
        self.isUpdated = false
    }
}
