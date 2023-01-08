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
    let animationDict: [String: AnimationInfo] = [
        "idle": AnimationInfo(count: 3, playType: .pingpong),
        "walk": AnimationInfo(count: 1, playType: .restart)
    ]
    var index = -1
    var adder = 1
    
    @objc func updateImage(imageView: NSImageView, animationName: String) {
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
}

class AnimationInfo {
    let count: Int!
    let playType: AnimationPlayType!

    init(count: Int, playType: AnimationPlayType) {
        self.count = count
        self.playType = playType
    }
}
