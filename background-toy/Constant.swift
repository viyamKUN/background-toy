//
//  Constant.swift
//  background-toy
//
//  Created by jeongukjae on 2023/01/27.
//

import Foundation
import Cocoa

struct Constant {
    // TODO: extract more hard-coded constants.
    struct Window {
        static let width = 120
        static let height = 120
        static let backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
    }

    struct Animation {
        static let frameRate = 10
        static let tickInterval = 0.02
    }

    struct State {
        static let stateTimer: [CharacterState: Int] = [
            .touch: 20,
            .playingcursor: 20,
        ]
        enum CharacterState: String {
            case idle, walk, grab, touch, playingcursor
        }
    }
}
