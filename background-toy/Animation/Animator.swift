//
//  animationController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/09.
//

import Foundation

class Animator {
    private var spriteFolderPath = ""
    private var clipMap: [String: Clip] = [:]
    private var index = -1
    private var adder = 1
    private var tickCount: Double = 0

    init(spriteFolderPath: String, clipMap: [String: Clip]) {
        self.spriteFolderPath = spriteFolderPath
        self.clipMap = clipMap
    }

    func getClip(_ name: String) -> Clip? {
        return clipMap[name]
    }

    func getUpdatedImagePath(
        animationName: String,
        isUpdated: Bool,
        tickInterval: Double
    ) -> String? {
        if isUpdated {
            reset()
        }

        // Calculate tick count for frame rate.
        tickCount += tickInterval
        if tickCount < (1.0 / Double(Constant.Animation.frameRate)) {
            return nil
        } else {
            tickCount = 0
        }

        // Update image index.
        guard let info = getClip(animationName) else { return nil }
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

        // Find image path.
        let imagePath = "\(animationName)_\(index)"
        return imagePath
    }

    private func reset() {
        index = -1
        adder = 1
    }
}

// TODO: read data from local file path, not bundle.
/// create animation data from local json file.
func newAnimator() throws -> Animator {
    if let path = Bundle.main.path(forResource: "animation", ofType: "json") {
        let s = try String(contentsOf: URL(filePath: path), encoding: .utf8)
        return try newAnimatorFromJSONString(s)
    } else {
        throw BTError.invalidPath
    }
}

func newAnimatorFromJSONString(_ s: String) throws -> Animator {
    let decoder = JSONDecoder()
    guard let jsonData = s.data(using: .utf8) else { throw BTError.invalidData }
    let animation = try decoder.decode(Animation.self, from: jsonData)

    let animator = Animator(spriteFolderPath: animation.spriteFolderPath, clipMap: animation.clips)
    return animator
}
