//
//  ChatGPTAPI.swift
//  ChatGPT
//
//  Created by Lucas Emiliano Benitez Joncic on 12/08/2023.
//

import Foundation
import OpenAI

let openAI = OpenAI(apiToken: "apiToken")

func getChatResponse(prompt: String) {
    let urlString = "https://api.openai.com/v1/chat/completions"
    
    guard let url = URL(string: urlString) else {
        print("URL is invalid")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(openAI)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let parameters: [String: Any] = [
        "messages": [
            ["role": "system", "content": "You are a helpful assistant."],
            ["role": "user", "content": prompt]
        ]
    ]
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpBody = jsonData
    } catch {
        print("Error creating JSON data: \(error)")
        return
    }
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        
        if let data = data {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let choices = json["choices"] as? [[String: Any]], let response = choices.first?["message"] as? [String: Any], let content = response["content"] as? String {
                        print("Chatbot response: \(content)")
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
    }
    
    task.resume()
}

func callChatGPT(prompt: String) async throws {
    let query = CompletionsQuery(model: .textDavinci_003, prompt: prompt, temperature: 0, maxTokens: 100, topP: 1, frequencyPenalty: 0, presencePenalty: 0, stop: ["\\n"])
    var message: String = ""
    for try await result in openAI.completionsStream(query: query) {
       //Handle result here
        message = "\(result.choices)"
    }
    //return message
}
