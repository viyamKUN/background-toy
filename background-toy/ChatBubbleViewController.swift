//
//  ChatBubbleViewController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/31.
//

import Cocoa

class ChatBubbleViewController: NSViewController {
    var message: String = ""

    override func viewWillAppear() {
        super.viewWillAppear()

        // TODO: implement
        print("Open chat bubble with message... \(message)")
    }
}
