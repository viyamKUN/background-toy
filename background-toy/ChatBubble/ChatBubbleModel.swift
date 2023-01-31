//
//  ChatBubbleModel.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/31.
//

import Cocoa
import Foundation

struct ChatBubblePayload {
    var parentWindow: NSWindow?
    var initialPosition = CGPoint(x: 0, y: 0)
    var appearingTimeLimit: Double = 0
    var message: String = ""
}

typealias ChatMessageMap = [String: ChatMessages]

typealias ChatMessages = [String]
