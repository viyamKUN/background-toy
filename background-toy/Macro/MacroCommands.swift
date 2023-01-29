//
//  MacroCommands.swift
//  background-toy
//
//  Created by 윤하연 on 2023/01/16.
//

import Cocoa
import Foundation

protocol Command {
    var path: String { get set }

    init(path: String)
    func execute()
}

class WebCommand: Command {
    var path: String

    required init(path: String) {
        self.path = path
    }

    func execute() {
        if let url = URL(string: path) {
            NSWorkspace.shared.open(url)
        }
    }
}

class ProcessCommand: Command {
    var path: String

    required init(path: String) {
        self.path = path
    }

    func execute() {
        let task = Process()
        task.arguments = ["-c", "open \(path)"]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        do {
            try task.run()
        } catch {
            print(error)
        }

    }
}
