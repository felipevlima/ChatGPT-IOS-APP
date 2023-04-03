//
//  ContentView.swift
//  ChatGPT
//
//  Created by Felipe Vieira Lima on 21/03/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var chatMessages: [ChatMessage] = []
    @State var message: String = ""
    let openAIService = OpenAIService()
    var isLoading: Bool = OpenAIService().isLoading
    
    @State var lastMessageID: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            HStack {
                Text("🤖 SwiftUI ChatGPT")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        ForEach(chatMessages, id: \.id) { message in
                            MessageView(message: message)
                        }
                    }
                }
                .onChange(of: self.lastMessageID) { id in
                    withAnimation{
                        proxy.scrollTo(id, anchor: .bottom)
                    }
                }
            }
            
            HStack {
                TextField("Enter a message", text: $message, axis: .vertical)
                    .lineLimit(1...5)
                    .padding()
//                    .background(colorScheme == .dark ? .gray.opacity(0.2) : .gray.opacity(0.3))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                        LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .leading, endPoint: .trailing), lineWidth: 2))
                    
                Button{
                    sendMessage()
                } label: {
                    if openAIService.isLoading {
                        ZStack {
                            Circle()
                                .frame(maxWidth: 44)
                            ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                        .padding(.horizontal, 5)
                    } else {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.8), .blue]), startPoint: .leading, endPoint: .trailing))
                                .frame(maxWidth: 44)
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 5)
                    }
                        
                }
                .disabled(openAIService.isLoading)
            }
            .padding(.top, 4)
        }
        .padding()
    }
        
    func sendMessage (){
        guard message != "" else {return}
        
        let myMessage = ChatMessage(id: UUID().uuidString, content: message, createdAt: Date(), sender: .me)
        chatMessages.append(myMessage)
        lastMessageID = myMessage.id
        
        openAIService.sendMessage(message: message).sink { completion in
            /// - Handle Error here
        } receiveValue: { response in
            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else {return}
            let chatGPTMessage = ChatMessage(id: response.id, content: textResponse, createdAt: Date(), sender: .chatGPT)
            
            chatMessages.append(chatGPTMessage)
            lastMessageID = chatGPTMessage.id
        }
        .store(in: &cancellables)
            
        message = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
