//
//  ChatProvider.swift
//  background-toy
//
//  Created by 윤하연 on 2023/02/01.
//

import Foundation

class ChatProvider {
    private var chatMessageMap: ChatMessageMap = [:]

    init(chatMessageMap: ChatMessageMap) {
        self.chatMessageMap = chatMessageMap
    }

    func getRandomChat() -> String {
        let timeRange = "morning"  // test
        if let messages = chatMessageMap[timeRange] {
            let max = messages.count - 1
            if max >= 0 {
                return messages[Int.random(in: 0...max)]
            }
        }
        return "Hello"
    }
}

// TODO: read data from local file path, not bundle.
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
