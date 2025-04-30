//
//  ChatService.swift
//  mySwiftUI
//
//  Created by Jeremy Wang on 4/28/25.
//

import Foundation

// A service class that handles communication with the OpenAI Chat Completion API.
// This service sends user queries and receives responses using a predefined system prompt.
class ChatService: ObservableObject {
    
    // Your OpenAI API key. Make sure to keep this key secure and do not expose it in production apps.
    // https://platform.openai.com/
    private let apiKey = "ENTER_YOUR_API_KEY_HERE_FOR_YOUR_FLAGLER_CHAT_ASSISTANT"
    
    // Sends a message to the OpenAI Chat Completion API and returns the assistant's reply.
    // - Parameters:
    //   - userInput: The user's input text to be sent to the assistant.
    //   - completion: A completion handler that returns the assistant's response as a String?.
    func sendMessage(_ userInput: String, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Define the role and knowledge of the chatbot using a system message
        // You can use prompt engeering here to make your Flagler app more customed. :)
        let systemPrompt = """
    You are Ask Saint, a helpful assistant trained on Flagler College academics and catalog. Provide accurate and student-friendly responses about majors, course offerings, graduation requirements, and academic policies.
    """
        
        // Build the messages array in chat format
        let messages: [[String: String]] = [
            ["role": "system", "content": systemPrompt],
            ["role": "user", "content": userInput]
        ]
        
        // Construct the request body for the OpenAI API
        let json: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages
        ]
        
        //Converting the Swift dictionary (json) into a JSON Data object that can be used as the HTTP request body in the API call.
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        // Create session with custom timeout
        let config = URLSessionConfiguration.default
        //If the request takes longer than 20 seconds to start sending or get a response, it will time out.
        config.timeoutIntervalForRequest = 20
        //If the whole exchange takes longer than 60 seconds, it will be canceled.
        config.timeoutIntervalForResource = 60
        let session = URLSession(configuration: config)
        
        // Retry wrapper
        func sendRequestWithRetry(request: URLRequest, retries: Int = 1) {
            session.dataTask(with: request) { data, _, error in
                if let error = error as NSError?, error.code == NSURLErrorNetworkConnectionLost, retries > 0 {
                    print("Network connection lost. Retrying...")
                    sendRequestWithRetry(request: request, retries: retries - 1)
                    return
                }
                
                // Parse response
                guard let data = data,
                      let response = try? JSONDecoder().decode(OpenAIResponse.self, from: data),
                      let reply = response.choices.first?.message.content else {
                    DispatchQueue.main.async {
                        completion("Sorry, something went wrong.")
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(reply)
                }
            }.resume()
        }
        
        // Actually call the retry function
        sendRequestWithRetry(request: request)
    }

}

// A struct representing the top-level response from the OpenAI Chat Completion API.
struct OpenAIResponse: Decodable {
    
    // A single choice in the response, which contains the assistant's message.
    struct Choice: Decodable {
        
        // The assistant's reply message.
        struct Message: Decodable {
            let content: String
        }
        
        let message: Message
    }
    
    let choices: [Choice]
}
