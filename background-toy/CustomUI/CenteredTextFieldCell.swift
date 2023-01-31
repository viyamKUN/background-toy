//
//  CenterTextField.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/31.
//

import Cocoa

class CenteredTextFieldCell: NSTextFieldCell {
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        let lineHeight: CGFloat = 16
        let newRect = NSRect(
            x: 0, y: (rect.size.height - lineHeight) / 2, width: rect.size.width, height: lineHeight
        )
        return super.drawingRect(forBounds: newRect)
    }
}
