//
//  MacroController.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/16.
//

import Foundation
import Cocoa

class MacroController {
    enum MacroType: String {
        case process, web
    }
    
    private let commandSet: [String: [MacroCommand]] = [
        "테스트1": [MacroCommand(name: "디스코드", path: "/Applications/Discord.app", type: .process),
                MacroCommand(name: "구글", path: "https://www.google.com/", type: .web)],
        "테스트2": [MacroCommand(name: "구글", path: "https://www.google.com/", type: .web)]
    ]
    
    func createMacroMenu(nsMenu: NSMenu) {
        // Create macro menus
        let macroMenu = NSMenu()
        let macroDropDown = NSMenuItem(title: "Macro", action: nil, keyEquivalent: "")
        nsMenu.addItem(macroDropDown)
        nsMenu.setSubmenu(macroMenu, for: macroDropDown)
        
        // attack macro menus to main menu
        commandSet.forEach { (key, commands) in
            let menu = NSMenuItem(title: key, action: #selector(MacroController.launchCommand(sender:)), keyEquivalent: "")
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
            case .process:
                openProgram(target: cmd.path)
            case .web:
                if let url = URL(string: cmd.path) {
                    NSWorkspace.shared.open(url)
                }
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

class MacroCommand {
    var name : String
    var path : String
    var type : MacroController.MacroType
    
    init(name: String, path: String, type: MacroController.MacroType) {
        self.name = name
        self.path = path
        self.type = type
    }
}
