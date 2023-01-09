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

        // Upddate states by time.
        updateTimer()
        // TODO: 스테이트 업데이트
        // 클릭, 걷기, idle이 시간 초과인 경우 idle
    }
    
    func updateTimer() {
        // 타이머가 등록된 애니메이션에 대해서
        // 타이머를 갱신
    }
    
    func resetEveryTick() {
        self.isUpdated = false
    }
}
