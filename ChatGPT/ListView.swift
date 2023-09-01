//
//  ListView.swift
//  ChatGPT
//
//  Created by Lucas Emiliano Benitez Joncic on 13/08/2023.
//

import SwiftUI

struct ListView: View {
    @Binding var conversations: [Conversation]
    @Binding var selectedConversationId: Conversation.ID?
    
    var body: some View {
        List(
            $conversations,
            editActions: [.delete],
            selection: $selectedConversationId
        ) { $conversation in
            Text(
                conversation.messages.last?.content ?? "New Conversation"
            )
            .lineLimit(2)
        }
        .navigationTitle("Conversations")
    }
}
