//
//  Model.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/30.
//

import Foundation

// The root of macro data file.
typealias MacroMap = [String: Macro]

typealias Macro = [Task]

struct Task: Codable {
    var type: String
    var payload: String
}
