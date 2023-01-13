//
//  ViewController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/08.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var characterImageView: NSImageView!
    let animator = AnimationController()
    let stateController = StateController()
    let systemState = SystemState()
    let movingController = MovingController()

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

        // Add timer
        let timer = Timer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(ViewController.updateEveryTick),
            userInfo: nil,
            repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    override func mouseDragged(with event: NSEvent) {
        view.window?.performDrag(with: event)
        systemState.isOnDragging = true
    }

    override func mouseUp(with event: NSEvent) {
        if systemState.isOnDragging {
            systemState.isOnDragging = false
        }
        else {
            systemState.isTouched = true
        }
    }
    
    func createContextMenuItems() -> [NSMenuItem] {
        let quit = NSMenuItem(title: "잘 가", action: #selector(ViewController.quit(sender:)), keyEquivalent: "")
        return [quit]
    }

    @objc func quit(sender: NSMenuItem) {
        NSApp.terminate(self)
    }
    
    @objc func updateEveryTick() {
        stateController.updateState(
            systemState: systemState)
        animator.updateImage(
            imageView: characterImageView,
            animationName: stateController.currentState.rawValue)
        movingController.updatePosition(
            window: view.window,
            stateController: stateController)
        
        // Resets
        stateController.resetEveryTick()
        systemState.resetEveryTick()
    }
}
