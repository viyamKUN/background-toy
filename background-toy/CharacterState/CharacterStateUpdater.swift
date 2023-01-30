//
//  CharacterStateUpdater.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/09.
//

import Foundation

class CharacterStateUpdater {
    var isUpdated: Bool = true
    var timer: Int = 0  // tick count
    var isTimerOn: Bool = false

    func getUpdateState(
        systemState: CharacterState, doNotDisturb: Bool
    )
        -> Constant.State.CharacterState
    {
        let currentState = systemState.currentState
        var newState = currentState

        // Update states by system.
        if systemState.isOnDragging {
            if currentState != .grab {
                newState = .grab
                turnOffTimer()
            }
        } else if systemState.isTouched {
            newState = .touch
            setTimer(tick: Constant.State.stateTimer[.touch] ?? 0)
        } else if systemState.isHover && currentState != .touch {
            if currentState != .playingcursor {
                newState = .playingcursor
                setTimer(tick: Constant.State.stateTimer[.playingcursor] ?? 0)
            }
        } else if isTimerOn {
            // Check exist timer status.
            if timer > 0 {
                // Timer is running... Do not update state.
                timer -= 1
                return currentState
            } else {
                turnOffTimer()
            }
        } else {
            var walkOrIdle = Constant.State.CharacterState.idle
            if doNotDisturb {
                walkOrIdle = .idle
            } else {
                walkOrIdle = Bool.random() ? .walk : .idle
            }
            if walkOrIdle != currentState {
                newState = walkOrIdle
                let timer = Int.random(in: 50...70)
                setTimer(tick: timer)
            }
        }
        if newState != currentState {
            isUpdated = true
        }
        return newState
    }

    private func turnOffTimer() {
        isTimerOn = false
        timer = 0
    }

    private func setTimer(tick: Int) {
        isTimerOn = true
        timer = tick
    }

    func resetEveryTick() {
        isUpdated = false
    }
}
