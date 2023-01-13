//
//  animationController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/09.
//

import Cocoa
import Foundation

enum AnimationPlayType {
    case restart, pingpong
}

class AnimationController {
    private let animationDict: [String: AnimationInfo] = [
        "idle": AnimationInfo(count: 3, playType: .pingpong),
        "walk": AnimationInfo(count: 7, playType: .restart),
        "grab": AnimationInfo(count: 3, playType: .pingpong),
        "touch": AnimationInfo(count: 5, playType: .pingpong),
        "playingcursor": AnimationInfo(count: 9, playType: .restart)
    ]
    private var index = -1
    private var adder = 1
    private var tickCount : Double = 0
    
    private let frameRate = 10
    
    func updateImage(
        imageView: NSImageView,
        animationName: String,
        isUpdated: Bool,
        tickInterval: Double
    ) {
        if isUpdated {
            reset()
        }
        
        // Calculate tick count for frame rate.
        tickCount += tickInterval
        if tickCount < (1.0 / Double(frameRate)) {
            return
        }
        else {
            tickCount = 0
        }
        
        // Change image.
        if let info = animationDict[animationName] {
            switch info.playType {
            case .restart:
                index = (index + 1) % info.count
            case .pingpong:
                index += adder
                if index + adder >= info.count || index + adder < 0 {
                    adder *= -1
                }
            case .none:
                print("Unexpected value")
            }
            imageView.image = NSImage(named: "\(animationName)_\(index)")
        }
    }
    
    private func reset() {
        index = -1
        adder = 1
    }
}

class AnimationInfo {
    let count: Int!
    let playType: AnimationPlayType!

    init(count: Int, playType: AnimationPlayType) {
        self.count = count
        self.playType = playType
    }
}
