//
//  Model.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/31.
//

import Foundation

struct Animation: Decodable {
    var spriteFolderPath: String
    var clips: Clips
}

typealias Clips = [Clip]

struct Clip: Decodable {
    var name: String
    var count: Int
    var playType: String
}
