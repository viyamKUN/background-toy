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

// TODO: read data from local file path, not bundle.
/// create macro executor data from local json file.
func newMacroExecutor() throws -> MacroExecutor {
    if let path = Bundle.main.path(forResource: "macro", ofType: "json") {
        let s = try String(
            contentsOf: URL(fileURLWithPath: path),
            encoding: .utf8)
        return try newMacroExecutorFromJSONString(s)
    }
    throw BTError.invalidPath
}

func newMacroExecutorFromJSONString(_ s: String) throws -> MacroExecutor {
    let decoder = JSONDecoder()
    guard let jsonData = s.data(using: .utf8) else { throw BTError.invalidData }
    let macroMap = try decoder.decode(MacroMap.self, from: jsonData)
    return MacroExecutor(macroMap: macroMap)
}

private func getCommand(_ type: String) throws -> Command {
    switch type {
    case "process":
        return ProcessCommand()
    case "web":
        return WebCommand()
    default:
        throw BTError.invalidCommand
    }
}
