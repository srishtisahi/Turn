//
//  FlashcardGenerator.swift
//  Turn2
//
//  Created by Srishti Sahi on 25/07/24.
//

import Foundation
import SwiftUI
import GoogleGenerativeAI

class FlashcardGenerator: ObservableObject {
    @Published var questionsAndAnswers: [(question: String, answer: String)] = []
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false

    func generateQuestions(topic: String, numberOfQuestions: Int) {
        guard numberOfQuestions > 0 && numberOfQuestions <= 100 else {
            showAlert = true
            return
        }

        isLoading = true
        let prompt = "Generate \(numberOfQuestions) one-liner question answers for the topic: \(topic)"

        Task {
            do {
                let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
                let response = try await model.generateContent(prompt)
                if let text = response.text {
                    let questions = text.components(separatedBy: "\n").filter { !$0.isEmpty }.map { line -> (String, String) in
                        let components = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
                        return (String(components[0]), components.count > 1 ? String(components[1]) : "")
                    }
                    DispatchQueue.main.async {
                        self.questionsAndAnswers = questions
                        self.isLoading = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.questionsAndAnswers = []
                        self.isLoading = false
                    }
                    print("No text received")
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("Error generating content: \(error)")
            }
        }
    }
}
