//
//  SystemStateController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/10.
//

import Foundation

class SystemState {
    var isOnDragging : Bool = false
    var isTouched : Bool = false
    var isMouseClose : Bool = false
    
    func resetEveryTick() {
        self.isTouched = false
    }
}
