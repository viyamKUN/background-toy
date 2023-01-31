//
//  ViewController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/08.
//

import Cocoa

class MainViewController: NSViewController {
    static var instance: MainViewController!

    @IBOutlet weak var characterImageView: NSImageView!

    private let characterStateUpdater = CharacterStateUpdater()
    private let windowPositionUpdater = WindowPositionUpdater()

    private var systemState = SystemState(
        characterState: Constant.State.CharacterState.idle, doNotDisturb: false)
    private var animator: Animator!
    private var macroExecutor: MacroExecutor!
    private var chatProvider: ChatProvider!

    private var chatBubblePayload: ChatBubblePayload!

    override func viewWillAppear() {
        super.viewWillAppear()

        MainViewController.instance = self

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
            chatProvider = try newChatProvider()
        } catch {
            print("Error info: \(error)")
        }

        // Add context menu
        view.menu = createMenu(macroExecutor)

        // Add timer
        let timer = Timer(
            timeInterval: Constant.Animation.tickInterval,
            target: self,
            selector: #selector(MainViewController.updateEveryTick),
            userInfo: nil,
            repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        let autoChatTimer = Timer(
            timeInterval: Constant.ChatBubble.autoChatInterval,
            target: self,
            selector: #selector(MainViewController.showAutoChat),
            userInfo: nil,
            repeats: true)
        RunLoop.main.add(autoChatTimer, forMode: RunLoop.Mode.common)

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

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.destinationController is ChatBubbleViewController {
            let viewController = segue.destinationController as? ChatBubbleViewController
            viewController?.payload = chatBubblePayload
        }
    }

    @objc func quit(sender: NSMenuItem) {
        NSApp.terminate(self)
    }

    @objc func changeTopmostOption(sender: NSMenuItem) {
        let isOn = sender.state == NSControl.StateValue.on
        sender.state = isOn ? NSControl.StateValue.off : NSControl.StateValue.on
        if isOn {
            view.window?.level = .normal
        } else {
            view.window?.level = .floating
        }
    }

    @objc func changeDisturbOption(sender: NSMenuItem) {
        let isOn = sender.state == NSControl.StateValue.on
        sender.state = isOn ? NSControl.StateValue.off : NSControl.StateValue.on
        systemState.doNotDisturb = !isOn
    }

    @objc func updateEveryTick() {
        // update system state
        if systemState.touchingTime < Constant.State.touchThreshold {
            systemState.touchingTime += 1
        }

        // update character state
        let newState = characterStateUpdater.getUpdatedState(
            systemState: systemState,
            doNotDisturb: systemState.doNotDisturb)
        systemState.characterState = newState

        // update window position
        let isWalk = systemState.characterState == .walk
        if isWalk {
            if let window = view.window {
                windowPositionUpdater.updatePosition(
                    window: window,
                    isStateUpdated: characterStateUpdater.isUpdated)
            }
        }

        // update character image
        if let imagePath = animator.getUpdatedImagePath(
            animationName: systemState.characterState.rawValue,
            isUpdated: characterStateUpdater.isUpdated,
            tickInterval: Constant.Animation.tickInterval)
        {
            characterImageView.image = NSImage(named: imagePath)?.flipped(
                flipHorizontally: windowPositionUpdater.isFlipped())
        }

        // Resets
        characterStateUpdater.resetEveryTick()
        systemState.isTouched = false
    }

    @objc func showAutoChat() {
        let hour = Calendar.current.component(.hour, from: Date())
        let chat = chatProvider.getRandomChat(hour)
        openChatBubbleView(chat, Constant.ChatBubble.autoChatTimeLimit)
    }

    func openChatBubbleView(_ message: String, _ appearingTimeLimit: Double) {
        chatBubblePayload = ChatBubblePayload(
            parentWindow: view.window,
            initialPosition: view.window?.frame.origin ?? CGPoint(x: 0, y: 0),
            appearingTimeLimit: appearingTimeLimit,
            message: message)
        performSegue(
            withIdentifier: "ShowChatBubble",
            sender: self)
    }
}

/// Create NSMenu and add menu items.
private func createMenu(_ macroExecutor: MacroExecutor) -> NSMenu {
    let contextMenu = NSMenu()

    let topmost = NSMenuItem(
        title: "최상단으로", action: #selector(MainViewController.changeTopmostOption(sender:)),
        keyEquivalent: "")
    topmost.state = NSControl.StateValue.on
    let doNotDisturb = NSMenuItem(
        title: "방해금지", action: #selector(MainViewController.changeDisturbOption(sender:)),
        keyEquivalent: "")
    let quit = NSMenuItem(
        title: "잘 가", action: #selector(MainViewController.quit(sender:)), keyEquivalent: "")

    let items = [topmost, doNotDisturb, quit]
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
