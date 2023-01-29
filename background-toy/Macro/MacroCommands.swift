//
//  MacroCommands.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/16.
//

import Cocoa
import Foundation

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
