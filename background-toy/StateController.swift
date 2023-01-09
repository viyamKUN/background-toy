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

    func updateState(systemState : SystemState) {
        // Update states by system.
        if systemState.isOnDragging {
            currentState = .grab
        }
        else if systemState.isTouched {
            currentState = .touch
        }
        else if systemState.isMouseClose {
            currentState = .playingcursor
        }
        else {
            currentState = .idle
        }

        // TODO: 스테이트 업데이트
        // 클릭, 걷기, idle이 시간 초과인 경우 idle
    }
    
    func resetEveryTick() {
        self.isUpdated = false
    }
}
