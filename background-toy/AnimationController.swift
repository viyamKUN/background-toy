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
    private var animationDict: [String: AnimationInfo] = [:]
    private var index = -1
    private var adder = 1
    private var tickCount: Double = 0

    private let frameRate = 10

    func readAnimationData() {
        if let path = Bundle.main.path(forResource: "animation", ofType: "csv") {
            do {
                let csvFile = try String(contentsOf: URL(filePath: path))
                let lines = csvFile.split(separator: "\n")[1...]
                for line in lines {
                    let elements = line.split(separator: ",")
                    animationDict[String(elements[0])] = AnimationInfo(
                        count: Int(elements[1]) ?? 0,
                        playType: String(elements[2]))
                }
            } catch {
                print("Fail to read animation data.")
            }
        }
    }

    func updateImage(
        imageView: NSImageView,
        animationName: String,
        isUpdated: Bool,
        tickInterval: Double,
        isFlipped: Bool
    ) {
        if isUpdated {
            reset()
        }

        // Calculate tick count for frame rate.
        tickCount += tickInterval
        if tickCount < (1.0 / Double(frameRate)) {
            return
        } else {
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
            imageView.image = NSImage(named: "\(animationName)_\(index)")?.flipped(
                flipHorizontally: isFlipped)
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

    init(count: Int, playType: String) {
        self.count = count
        switch playType {
        case "pingpong":
            self.playType = .pingpong
        case "restart":
            self.playType = .restart
        default:
            self.playType = .none
        }
    }
}
