//
//  MacroExecutor.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/30.
//

import Cocoa
import Foundation

struct Macro {
    var command: [Command]
}

class MacroExecutor {
    private var commandMap: [String: Macro] = [:]

    func registerMacro(_ name: String, _ command: Macro) {
        commandMap[name] = command
    }

    func createMacroMenu(nsMenu: NSMenu) {
        // Create macro menus
        let macroMenu = NSMenu()
        let macroDropDown = NSMenuItem(title: "Macro", action: nil, keyEquivalent: "")
        nsMenu.addItem(macroDropDown)
        nsMenu.setSubmenu(macroMenu, for: macroDropDown)

        // attack macro menus to main menu
        commandMap.forEach { (key, commands) in
            let menu = NSMenuItem(
                title: key, action: #selector(MacroExecutor.executeSet(sender:)),
                keyEquivalent: "")
            menu.target = self
            macroMenu.addItem(menu)
        }
    }

    @objc private func executeSet(sender: NSMenuItem) {
        let commands = commandMap[sender.title]?.command
        commands?.forEach { (cmd) in
            cmd.execute()
            print(cmd.path)
        }
    }
}

func readMacroData(executor: MacroExecutor) {
    if let path = Bundle.main.path(forResource: "macro", ofType: "json") {
        do {
            let jsonData = try Data(
                contentsOf: URL(fileURLWithPath: path),
                options: Data.ReadingOptions.mappedIfSafe)
            let resultObject = try JSONSerialization.jsonObject(
                with: jsonData, options: JSONSerialization.ReadingOptions.mutableLeaves)
            if let jsonResults = resultObject as? [String: [[String: String]]] {
                for result in jsonResults {
                    var macro = Macro(command: [])
                    for cmd in result.value {
                        let command = getCommand(type: cmd["type"]!, payload: cmd["path"]!)
                        if command != nil {
                            macro.command.append(command!)
                        }
                    }
                    executor.registerMacro(result.key, macro)
                }
            }
        } catch {
            print("Fail to read data")
        }
    }
}

private func getCommand(type: String, payload: String) -> Command? {
    switch type {
    case "process":
        return ProcessCommand(path: payload)
    case "web":
        return WebCommand(path: payload)
    default:
        return nil
    }
}
