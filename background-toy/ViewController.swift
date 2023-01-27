//
//  ViewController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/08.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var characterImageView: NSImageView!
    private let animator = AnimationController()
    private let stateController = StateController()
    private let systemState = SystemState()
    private let movingController = MovingController()
    private let macroController = MacroController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        // Set size and position
        view.window?.setContentSize(
            NSSize(width: Constant.Window.width, height: Constant.Window.height))
        view.setFrameOrigin(NSPoint(x: 0, y: 0))
        view.window?.center()

        // Set transparent background
        view.window?.isOpaque = false
        view.window?.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)

        // Read data
        animator.readAnimationData()
        macroController.readMacroData()

        // Add context menu
        let contextMenu = NSMenu()
        let items = createContextMenuItems()
        items.forEach(contextMenu.addItem)
        macroController.createMacroMenu(nsMenu: contextMenu)
        view.menu = contextMenu

        // Add timer
        let timer = Timer(
            timeInterval: Constant.Animation.tickInterval,
            target: self,
            selector: #selector(ViewController.updateEveryTick),
            userInfo: nil,
            repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)

        let trackingArea = NSTrackingArea(
            rect: NSRect(x: 0, y: 0, width: Constant.Window.width, height: Constant.Window.height),
            options: [
                NSTrackingArea.Options.activeAlways, NSTrackingArea.Options.mouseEnteredAndExited,
            ],
            owner: self)
        view.addTrackingArea(trackingArea)
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.level = .floating
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
        } else if systemState.isTouchingTimeInTouchRange() {
            systemState.isTouched = true
        }
    }

    override func mouseDown(with event: NSEvent) {
        systemState.touchingTime = 0
    }

    override func mouseEntered(with event: NSEvent) {
        systemState.isHover = true
    }

    override func mouseExited(with event: NSEvent) {
        systemState.isHover = false
    }

    func createContextMenuItems() -> [NSMenuItem] {
        let quit = NSMenuItem(
            title: "잘 가", action: #selector(ViewController.quit(sender:)), keyEquivalent: "")
        return [quit]
    }

    @objc func quit(sender: NSMenuItem) {
        NSApp.terminate(self)
    }

    @objc func updateEveryTick() {
        // update system
        systemState.updateTouchingTime()

        // update controllers
        stateController.updateState(
            systemState: systemState)
        movingController.updatePosition(
            window: view.window,
            stateController: stateController)
        animator.updateImage(
            imageView: characterImageView,
            animationName: stateController.currentState.rawValue,
            isUpdated: stateController.isUpdated,
            tickInterval: Constant.Animation.tickInterval,
            isFlipped: movingController.isFlipped())

        // Resets
        stateController.resetEveryTick()
        systemState.resetEveryTick()
    }
}
