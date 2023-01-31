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

    var parentWindow: NSWindow?
    var message: String = ""
    var initialPosition = CGPoint(x: 0, y: 0)

    override func viewWillAppear() {
        super.viewWillAppear()

        // Set default settings
        view.window?.styleMask = .borderless

        // Set size and position
        view.window?.setContentSize(
            NSSize(width: Constant.ChatBubbleWindow.width, height: Constant.ChatBubbleWindow.height)
        )
        view.window?.setFrameOrigin(initialPosition)

        // Set background color
        view.window?.isOpaque = false
        view.window?.backgroundColor = Constant.ChatBubbleWindow.backgroundColor

        // Add timer
        let timer = Timer(
            timeInterval: Constant.Animation.tickInterval,
            target: self,
            selector: #selector(ChatBubbleViewController.updateEveryTick),
            userInfo: nil,
            repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)

        // Set message
        chatField.stringValue = message
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.level = .floating
    }

    @objc func updateEveryTick() {
        // Follow main view
        var desiredPosition = parentWindow?.frame.origin ?? CGPoint(x: 0, y: 0)
        let offset = Constant.ChatBubbleWindow.positionOffsetFromMainWindow
        desiredPosition = CGPoint(x: desiredPosition.x + offset.x, y: desiredPosition.y + offset.y)
        view.window?.setFrameOrigin(desiredPosition)
    }
}
