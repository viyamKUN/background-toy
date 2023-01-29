//
//  MacroExecutor.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/30.
//

import Cocoa
import Foundation

class MacroExecutor {
    struct Macro {
        var name: String
        var path: String
        var command: Command?
    }

    private var commandSet: [String: [Macro]] = [:]

    private let webCommand = WebCommand()
    private let processCommand = ProcessCommand()

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
                            var command = getCommand(type: cmd["type"]!)
                            commandSet[result.key]?.append(
                                Macro(
                                    name: cmd["name"]!,
                                    path: cmd["path"]!,
                                    command: command))
                        }
                    }
                }
            } catch {
                print("Fail to read data")
            }
        }
    }

    private func getCommand(type: String) -> Command? {
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
                title: key, action: #selector(MacroExecutor.executeSet(sender:)),
                keyEquivalent: "")
            menu.target = self
            macroMenu.addItem(menu)
        }
    }

    @objc private func executeSet(sender: NSMenuItem) {
        let commands = commandSet[sender.title]
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
