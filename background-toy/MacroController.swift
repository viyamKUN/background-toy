//
//  MacroController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/16.
//

import Cocoa
import Foundation

class MacroController {
    struct MacroCommand {
        var name: String
        var path: String
        var command: Command?
    }

    private var commandSet: [String: [MacroCommand]] = [:]
    let webCommand = WebCommand()
    let processCommand = ProcessCommand()

    func readMacroData() {
        if let path = Bundle.main.path(forResource: "macro", ofType: "json") {
            do {
                let jsonData = try Data(
                    contentsOf: URL(fileURLWithPath: path),
                    options: Data.ReadingOptions.mappedIfSafe)
                let resultObject = try JSONSerialization.jsonObject(
                    with: jsonData, options: JSONSerialization.ReadingOptions.mutableLeaves)
                if let jsonResults = resultObject as? [String: [[String: String]]] {
                    for result in jsonResults {
                        for cmd in result.value {
                            if commandSet[result.key] == nil {
                                commandSet[result.key] = []
                            }
                            commandSet[result.key]?.append(
                                MacroCommand(
                                    name: cmd["name"]!,
                                    path: cmd["path"]!,
                                    command: getCommand(type: cmd["type"]!)))
                        }
                    }
                }
            } catch {
                print("Fail to read data")
            }
        }
    }

    func getCommand(type: String) -> Command? {
        switch type {
        case "process":
            return processCommand
        case "web":
            return webCommand
        default:
            return nil
        }
    }

    func createMacroMenu(nsMenu: NSMenu) {
        // Create macro menus
        let macroMenu = NSMenu()
        let macroDropDown = NSMenuItem(title: "Macro", action: nil, keyEquivalent: "")
        nsMenu.addItem(macroDropDown)
        nsMenu.setSubmenu(macroMenu, for: macroDropDown)

        // attack macro menus to main menu
        commandSet.forEach { (key, commands) in
            let menu = NSMenuItem(
                title: key, action: #selector(MacroController.launchCommand(sender:)),
                keyEquivalent: "")
            menu.target = self
            macroMenu.addItem(menu)
        }
    }

    @objc private func launchCommand(sender: NSMenuItem) {
        let commands = commandSet[sender.title]
        if commands == nil || commands?.count == 0 {
            return
        }
        commands?.forEach { (cmd) in
            if cmd.command != nil {
                cmd.command?.execute(payload: cmd.path)
            } else {
                print("[\(cmd.name)]: Command type not supported.")
            }
            print(cmd.path)
        }
    }
}

class WebCommand: Command {
    func execute(payload: String) {
        if let url = URL(string: payload) {
            NSWorkspace.shared.open(url)
        }
    }
}

class ProcessCommand: Command {
    func execute(payload: String) {
        let task = Process()
        task.arguments = ["-c", "open \(payload)"]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        do {
            try task.run()
        } catch {
            print(error)
        }

    }
}

protocol Command {
    func execute(payload: String)
}
