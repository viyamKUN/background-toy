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
        // Update states by system.
        if systemState.isOnDragging {
            if currentState != .grab {
                updateState(newState: .grab)
            }
        }
        else if systemState.isTouched {
            updateState(newState: .touch)
            setTimer(tick: stateTimer[.touch] ?? 0)
        }
        else if isTimerOn{
            // Check exist timer status.
            if timer > 0 {
                // Timer is running... Do not update state.
                timer -= 1
                return
            }
            else {
                turnOffTimer()
            }
        }
        else if systemState.isMouseClose {
            updateState(newState: .playingcursor)
        }
        else {
            let newState : CharacterState = Bool.random() ? .walk : .idle
            if newState != currentState {
                updateState(newState: newState)
                let timer = Int.random(in: 50...70)
                setTimer(tick: timer)
            }
        }
    }
    
    private func updateState(newState : CharacterState) {
        isUpdated = true
        currentState = newState
        turnOffTimer()
    }
    
    func turnOffTimer() {
        timer = 0
        isTimerOn = false
    }
    
    func setTimer(tick: Int) {
        isTimerOn = true
        timer = tick
    }
    
    func resetEveryTick() {
        isUpdated = false
    }
}
