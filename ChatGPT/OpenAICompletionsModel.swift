//
//  OpenAICompletionsModel.swift
//  ChatGPT
//
//  Created by Felipe Vieira Lima on 21/03/23.
//

import Foundation

struct OpenAICompletionsBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int
}
struct OpenAIResponse: Decodable {
    let id: String
    let choices: [OpenAIResponseChoice]
}
struct OpenAIResponseChoice: Decodable {
    let text: String
}
