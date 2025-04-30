//
//  ChatView.swift
//  mySwiftUI
//
//  Created by Jeremy Wang on 4/28/25.
//

import SwiftUI

// The main chat view for the Ask Saint app, responsible for displaying messages and handling user input.
struct ChatView: View {
    // The text currently entered by the user.
    @State private var inputText = ""
    
    // The list of chat messages between the user and the assistant.
    @State private var messages: [Message] = []
    
    // Instance of ChatService to handle OpenAI API calls.
    @ObservedObject var chatService = ChatService()
    
    var body: some View {
        VStack {
            // Scrollable message view with auto-scroll to the latest message.
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isUser {
                                    Spacer()
                                    // Display user message with blue background.
                                    Text(message.content)
                                        .padding()
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(10)
                                        .id(message.id) // Tag for scroll position
                                } else {
                                    // Display assistant message with gray background.
                                    Text(message.content)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                        .id(message.id)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                // Automatically scroll to the bottom when a new message is added.
                .onChange(of: messages.count) { _ in
                    if let last = messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            // Input field and send button.
            HStack {
                // Text input for the user’s message.
                TextField("Ask about courses, majors...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Button to send the message.
                Button("Send") {
                    sendMessage()
                }
            }
            .padding()
        }
        // Set the title of the navigation bar.
        .navigationTitle("Ask Saint")
    }
    
    // Sends the user's message to the assistant and appends both messages to the chat.
    private func sendMessage() {
        // Create and add the user message.
        let userMessage = Message(content: inputText, isUser: true)
        messages.append(userMessage)
        
        // Hide the keyboard after the chat entry
        UIApplication.shared.endEditing()
        
        // Call the ChatService to send the input text and receive a response.
        chatService.sendMessage(inputText) { response in
            if let reply = response {
                // Append the assistant's reply to the chat.
                let botMessage = Message(content: reply, isUser: false)
                messages.append(botMessage)
            }
        }
        
        // Clear the input text field.
        inputText = ""
    }
}

extension UIApplication {
    // Hides the keyboard by ending editing on the key window
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// Preview provider for SwiftUI canvas.
#Preview {
    ChatView()
}
