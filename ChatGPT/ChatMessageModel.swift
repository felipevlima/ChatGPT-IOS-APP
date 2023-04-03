//
//  ChatMessageModel.swift
//  ChatGPT
//
//  Created by Felipe Vieira Lima on 21/03/23.
//

import Foundation

struct ChatMessage {
    let id: String
    let content: String
    let createdAt: Date
    let sender: MessageSender
}

enum MessageSender {
    case me
    case chatGPT
}
