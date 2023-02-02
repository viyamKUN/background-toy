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

func editJSONfile() throws {
    let target = "animation"
    if let filepath = Bundle.main.path(forResource: target, ofType: "json") {
        do {
            let contents = try String(contentsOfFile: filepath)
            print(contents)
        } catch {
            throw BTError.invalidData
        }
    } else {
        throw BTError.invalidPath
    }
}

func copyFile() {
    if let resourcePath = Bundle.main.resourcePath {
        do {
            let docsArray = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
            for document in docsArray {
                if document.hasSuffix(".json") {
                    let resourceName = document.replacingOccurrences(of: ".json", with: "")
                    if let filePath = Bundle.main.path(forResource: resourceName, ofType: "json") {
                        let content = try String(contentsOfFile: filePath)
                        let isSuccess = tryCreateFile(content, getDocumentDirectory(), document)
                        if !isSuccess {
                            print("Fail to copy files. Use default file in bundle.")
                        } else {
                            print("\(document) copied!!!")
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    //    tryCreateFile("이런 내용을 적을거야.", getDocumentDirectory(), "test.txt")
}

private func tryCreateFile(_ content: String, _ folderURL: URL, _ fileName: String) -> Bool {
    let filePath = folderURL.appending(path: fileName).relativePath
    print(filePath)
    let data = content.data(using: .utf8)
    let isSuccess = FileManager.default.createFile(
        atPath: filePath,
        contents: data, attributes: nil)
    return isSuccess
}

private func tryWriteFile(_ content: String, _ folderURL: URL, _ fileName: String) throws {
    do {
        let fileURL = folderURL.appending(path: fileName).relativePath
        try content.write(toFile: fileURL, atomically: true, encoding: .utf8)
    } catch {
        throw BTError.invalidPath
    }
}

private func getDocumentDirectory() -> URL {
    let documentsURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return documentsURLs[0]
}
