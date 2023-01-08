//
//  StateController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/09.
//

import Foundation

class StateController {
    enum CharacterState {
        case idle, walk, grab, touch, playingcursor
    }
    var currentState: CharacterState = .idle
    var isUpdated: Bool = true

    @objc func updateState() {
        // TODO: 스테이트 업데이트
        // 드래그 중 -> grab
        // 마우스와 가까움 -> playing cursor
        // 클릭 -> touch
        // 클릭, 걷기, idle이 시간 초과인 경우 idle
    }
    
    @objc func resetEveryTick() {
        self.isUpdated = false
    }
}
