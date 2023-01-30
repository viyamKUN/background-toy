//
//  Model.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/31.
//

import Foundation

struct Animation {
    var spriteFolderPath: String
    var clip: [Clip]
}

struct Clip {
    var name: String
    var count: Int
    var playType: String
}
