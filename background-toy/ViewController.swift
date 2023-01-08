//
//  ViewController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/08.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        // Set size and position
        view.window?.setContentSize(NSSize(width: 120, height: 120))
        view.setFrameOrigin(NSPoint(x: 0, y: 0))
        view.window?.center()

        // Set transparent background
        view.window?.isOpaque = false
        view.window?.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        // Add context menu
        let contextMenu = NSMenu()
        let items = createContextMenuItems()
        items.forEach(contextMenu.addItem)
        view.menu = contextMenu
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    override func mouseDragged(with event: NSEvent) {
        view.window?.performDrag(with: event)
    }
    
    func createContextMenuItems() -> [NSMenuItem] {
        let quit = NSMenuItem(title: "잘 가", action: #selector(ViewController.quit(sender:)), keyEquivalent: "")
        return [quit]
    }

    @objc func quit(sender: NSMenuItem) {
        NSApp.terminate(self)
    }
}

