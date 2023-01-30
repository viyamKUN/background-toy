//
//  ViewController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/08.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var characterImageView: NSImageView!
    private let stateController = StateController()
    private let systemState = SystemState()
    private let positionUpdater = PositionUpdater()
    private var animator: Animator!
    private var macroExecutor: MacroExecutor!

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
        view.window?.backgroundColor = Constant.Window.backgroundColor

        // Read data
        do {
            animator = try newAnimator()
            macroExecutor = try newMacroExecutor()
        } catch {
            print("Error info: \(error)")
        }

        // Add context menu
        view.menu = createMenu(macroExecutor)

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

    @objc func quit(sender: NSMenuItem) {
        NSApp.terminate(self)
    }

    @objc func updateEveryTick() {
        // update system
        systemState.updateTouchingTime()

        // update controllers
        stateController.updateState(
            systemState: systemState)

        let isWalking = stateController.currentState == .walk
        if isWalking {
            if let window = view.window {
                positionUpdater.updatePosition(
                    window: window,
                    isStateUpdated: stateController.isUpdated)
            }
        }
        if let imagePath = animator.getUpdatedImagePath(
            animationName: stateController.currentState.rawValue,
            isUpdated: stateController.isUpdated,
            tickInterval: Constant.Animation.tickInterval)
        {
            characterImageView.image = NSImage(named: imagePath)?.flipped(
                flipHorizontally: positionUpdater.isFlipped())
        }

        // Resets
        stateController.resetEveryTick()
        systemState.resetEveryTick()
    }
}

/// Create NSMenu and add menu items.
private func createMenu(_ macroExecutor: MacroExecutor) -> NSMenu {
    let contextMenu = NSMenu()

    let quit = NSMenuItem(
        title: "잘 가", action: #selector(ViewController.quit(sender:)), keyEquivalent: "")
    // TODO: Add more menu items

    let items = [quit]
    items.forEach(contextMenu.addItem)

    // Create macro menu items
    let macroMenu = NSMenu()
    let macroDropDown = NSMenuItem(title: "Macro", action: nil, keyEquivalent: "")
    contextMenu.addItem(macroDropDown)
    contextMenu.setSubmenu(macroMenu, for: macroDropDown)

    // Attach macro menus to main menu
    let macroMap = macroExecutor.listMacros()
    macroMap.forEach { (key, commands) in
        let menu = NSMenuItem(
            title: key, action: #selector(MacroExecutor.execute(sender:)),
            keyEquivalent: "")
        menu.target = macroExecutor
        macroMenu.addItem(menu)
    }

    return contextMenu
}
