//
//  JsonReader.swift
//  background-toy
//
//  Created by 윤하연 on 2023/02/02.
//

import Foundation

/// create animation data from local json file.
func newAnimator() throws -> Animator {
    if let path = Bundle.main.path(forResource: "animation", ofType: "json") {
        let s = try String(contentsOf: URL(filePath: path), encoding: .utf8)
        return try newAnimatorFromJSONString(s)
    } else {
        throw BTError.invalidPath
    }
}

func newAnimatorFromJSONString(_ s: String) throws -> Animator {
    let decoder = JSONDecoder()
    guard let jsonData = s.data(using: .utf8) else { throw BTError.invalidData }
    let animation = try decoder.decode(Animation.self, from: jsonData)

    let animator = Animator(spriteFolderPath: animation.spriteFolderPath, clipMap: animation.clips)
    return animator
}

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

/// create macro executor data from local json file.
func newChatProvider() throws -> ChatProvider {
    if let path = Bundle.main.path(forResource: "chat", ofType: "json") {
        let s = try String(
            contentsOf: URL(fileURLWithPath: path),
            encoding: .utf8)
        return try newChatProviderFromJSONString(s)
    }
    throw BTError.invalidPath
}

func newChatProviderFromJSONString(_ s: String) throws -> ChatProvider {
    let decoder = JSONDecoder()
    guard let jsonData = s.data(using: .utf8) else { throw BTError.invalidData }
    let chatMessageMap = try decoder.decode(ChatMessageMap.self, from: jsonData)
    return ChatProvider(chatMessageMap: chatMessageMap)
}
