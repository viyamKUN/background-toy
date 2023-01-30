//
//  Errors.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/30.
//

import Foundation

enum BTError: Error {
    // rasised when the BT met invalid data
    case invalidData
    // raised when cannot find command
    case invalidCommand
    // raised when cannot find macro with desired name
    case invalidMacroName
    // raised when cannot find desired file path
    case invalidPath
}
