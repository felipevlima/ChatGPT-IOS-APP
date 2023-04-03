//
//  MessageView.swift
//  ChatGPT
//
//  Created by Felipe Vieira Lima on 21/03/23.
//

import SwiftUI

struct MessageView: View {
    var message: ChatMessage
    
    var body: some View {
        HStack {
            if message.sender == .me{Spacer()}
            Text(message.content)
                .foregroundColor(message.sender == .me ? .white : nil)
                .padding()
                .background(message.sender == .me ? LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), .blue]), startPoint: .bottom, endPoint: .top) : LinearGradient(gradient: Gradient(colors: [.gray.opacity(0.4)]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(24)
            if message.sender == .chatGPT{Spacer()}
        }
    }
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView()
//    }
//}
