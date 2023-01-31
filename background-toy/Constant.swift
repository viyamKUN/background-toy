//
//  Constant.swift
//  background-toy
//
//  Created by jeongukjae on 2023/01/27.
//

import Cocoa
import Foundation

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
        enum CharacterState: String {
            case idle, walk, grab, touch, playingcursor
        }
        static let stateTimer: [CharacterState: Int] = [
            .touch: 20,
            .playingcursor: 20,
        ]
        static let touchThreshold = 10
    }

    struct ChatBubbleWindow {
        static let width = 200
        static let height = 100
        static let backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
        static let positionOffsetFromMainWindow = CGPoint(x: 0, y: 100)
    }

    struct ChatBubble {
        static let autoChatInterval: Double = 300
        static let autoChatTimeLimit: Double = 3
        static let macroChatTimeLimit: Double = 3
    }
}
