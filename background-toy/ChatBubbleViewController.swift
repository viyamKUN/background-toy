//
//  ChatBubbleViewController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/31.
//

import Cocoa

class ChatBubbleViewController: NSViewController {
    @IBOutlet weak var chatField: NSTextField!
    @IBOutlet weak var imageView: NSImageView!

    var message: String = ""
    var initialPosition = NSPoint(x: 0, y: 0)

    override func viewWillAppear() {
        super.viewWillAppear()

        // Set size and position
        view.window?.setContentSize(
            NSSize(width: Constant.ChatBubbleWindow.width, height: Constant.ChatBubbleWindow.height)
        )
        view.window?.setFrameOrigin(initialPosition)

        // Set background color
        view.window?.isOpaque = false
        view.window?.backgroundColor = Constant.ChatBubbleWindow.backgroundColor

        // Set message
        chatField.stringValue = message
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.level = .floating
    }
}
