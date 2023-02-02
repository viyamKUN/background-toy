//
//  MacroExecutor.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/30.
//

import Cocoa
import Foundation

class MacroExecutor {
    private var macroMap: MacroMap = [:]

    init(macroMap: MacroMap) {
        self.macroMap = macroMap
    }

    func listMacros() -> [(String, Macro)] {
        var macroList: [(String, Macro)] = []
        for (key, macro) in macroMap {
            macroList.append((key, macro))
        }
        return macroList
    }

    func getMacro(_ name: String) -> Macro? {
        return macroMap[name]
    }

    /// Execute macro by menu item's name.
    @objc func execute(sender: NSMenuItem) {
        do {
            try execute(sender.title)
        } catch {
            // TODO: add logger.log here
            print("Error info: \(error)")
        }
    }

    func execute(_ name: String) throws {
        if let macro = getMacro(name) {
            try macro.forEach { (task) in
                let cmd = try getCommand(task.type)
                cmd.execute(task.payload)
                print(task.payload)
            }
        } else {
            throw BTError.invalidMacroName
        }
    }
}

private func getCommand(_ type: String) throws -> Command {
    switch type {
    case "process":
        return ProcessCommand()
    case "web":
        return WebCommand()
    case "chat":
        return ChatCommand()
    default:
        throw BTError.invalidCommand
    }
}
