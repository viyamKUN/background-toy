//
//  MacroExecutor.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/30.
//

import Cocoa
import Foundation

struct Macro {
    var tasks: [MacroTask]
}

struct MacroTask {
    var command: Command
    var payload: String
}

class MacroExecutor {
    private var macroMap: [String: Macro] = [:]

    func registerMacro(_ name: String, _ macro: Macro) {
        macroMap[name] = macro
    }

    func listMacros() -> [(String, Macro)] {
        var macroList: [(String, Macro)] = []
        for (key, macro) in macroMap {
            macroList.append((key, macro))
        }
        return macroList
    }

    /// Execute macro by menu item's name.
    @objc func execute(sender: NSMenuItem) {
        execute(sender.title)
    }

    func execute(_ name: String) {
        if let macro = macroMap[name] {
            let commands = macro.tasks
            commands.forEach { (cmd) in
                cmd.command.execute(cmd.payload)
                print(cmd.payload)
            }
        }
    }
}

/// Read macro data from local json file.
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
                    var macro = Macro(tasks: [])
                    for cmd in result.value {
                        if let command = getCommand(type: cmd["type"]!) {
                            macro.tasks.append(
                                MacroTask(command: command, payload: cmd["path"]!))
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

private func getCommand(type: String) -> Command? {
    switch type {
    case "process":
        return ProcessCommand()
    case "web":
        return WebCommand()
    default:
        return nil
    }
}
