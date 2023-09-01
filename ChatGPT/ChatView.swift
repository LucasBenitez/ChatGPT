//
//  ChatView.swift
//  ChatGPT
//
//  Created by Lucas Emiliano Benitez Joncic on 12/08/2023.
//

import SwiftUI

struct Message: Identifiable {
    var id = UUID()
    var text: String
    var isFromUser: Bool
}

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var newMessage = ""
    @State private var messageReceived = ""
    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages, id: \.id) { message in
                    Text(message.text)
                        .padding(10)
                        .background(message.isFromUser ? Color.blue : Color.gray)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(5)
                }
                
            }
            
            HStack {
                TextField("Type a message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    Task {
                        await sendMessage()
                    }
                }) {
                    Text("Send")
                }
            }
            .padding()
        }
        .navigationBarTitle("Chat with AI")
    }

    func sendMessage() async {
        // Llamar a la función para realizar la solicitud a la API de GPT-3
        messages.append(Message(text: newMessage, isFromUser: true))
        do {
            let responseMessage = try await callChatGPT(prompt: newMessage)
            DispatchQueue.main.async {
                messages.append(Message(text: "\(responseMessage)", isFromUser: false))
            }
        } catch {
            print("Error fetching chat response: \(error)")
        }
        
        newMessage = ""
    }

}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
