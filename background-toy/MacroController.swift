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
        var type: String
    }

    private var commandSet: [String: [MacroCommand]] = [:]

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
                                    type: cmd["type"]!))
                        }
                    }
                }
            } catch {
                print("Fail to read data")
            }
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
            switch cmd.type {
            case "process":
                openProgram(target: cmd.path)
            case "web":
                if let url = URL(string: cmd.path) {
                    NSWorkspace.shared.open(url)
                }
            default:
                print("Command type \(cmd.type) not supported.")
            }
            print(cmd.path)
        }
    }

    private func openProgram(target: String) {
        let task = Process()
        let command = "open \(target)"
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        do {
            try task.run()
        } catch {
            print(error)
        }
    }
}
