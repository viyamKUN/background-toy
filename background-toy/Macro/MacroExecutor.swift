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
    @objc func executeSet(sender: NSMenuItem) {
        let commands = macroMap[sender.title]?.command
        commands?.forEach { (cmd) in
            cmd.execute()
            print(cmd.path)
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
