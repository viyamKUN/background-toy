//
//  animationController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/09.
//

import Cocoa
import Foundation

class AnimationController {
    private var spriteFolderPath = ""
    private var clipMap: [String: Clip] = [:]
    private var index = -1
    private var adder = 1
    private var tickCount: Double = 0

    private func registerClip(_ name: String, _ clip: Clip) {
        clipMap[name] = clip
    }

    func registerAnimation(_ animation: Animation) {
        spriteFolderPath = animation.spriteFolderPath
        for clip in animation.clips {
            registerClip(clip.name, clip)
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
        if tickCount < (1.0 / Double(Constant.Animation.frameRate)) {
            return
        } else {
            tickCount = 0
        }

        // Change image.
        if let info = clipMap[animationName] {
            switch info.playType {
            case "restart":
                index = (index + 1) % info.count
            case "pingpong":
                index += adder
                if index + adder >= info.count || index + adder < 0 {
                    adder *= -1
                }
            default:
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

// TODO: read data from local file path, not bundle.
/// create animation data from local json file.
func newAnimator() throws -> AnimationController {
    if let path = Bundle.main.path(forResource: "animation", ofType: "json") {
        let s = try String(contentsOf: URL(filePath: path), encoding: .utf8)
        return try newAnimatorFromJSONString(s)
    } else {
        throw BTError.invalidPath
    }
}

func newAnimatorFromJSONString(_ s: String) throws -> AnimationController {
    let decoder = JSONDecoder()
    guard let jsonData = s.data(using: .utf8) else { throw BTError.invalidData }
    let animation = try decoder.decode(Animation.self, from: jsonData)

    let animator = AnimationController()
    animator.registerAnimation(animation)
    return animator
}
