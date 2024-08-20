//
//  ContentView.swift
//  Turn2
//
//  Created by Srishti Sahi on 24/07/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var flashcardGenerator = FlashcardGenerator()
    @State private var inputText: String = ""
    @State private var numberOfCards: String = ""
    @State private var showFlashcards: Bool = false
    @State private var presentAlert: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Create a new Flashcard Deck")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.top, 20)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Label("Biological Classification of Species", systemImage: "leaf.fill")
                            .padding(.horizontal)
                        Label("History of the French Revolution", systemImage: "book.closed")
                            .padding(.horizontal)
                        Label("The Merchant of Venice by William Shakespeare", systemImage: "theatermasks.fill")
                            .padding(.horizontal)
                    }

                    TextField("Write your topic here...", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    HStack {
                        Text("How many flashcards do you want? (maximum 100)")
                        Spacer()
                        TextField("0", text: $numberOfCards)
                            .keyboardType(.numberPad)
                            .frame(width: 50)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding()

                    if flashcardGenerator.isLoading {
                        ProgressView("Generating flashcards...")
                            .padding()
                    } else {
                        Button("Generate") {
                            if let numCards = Int(numberOfCards), numCards > 0 && numCards <= 100 {
                                flashcardGenerator.generateQuestions(topic: inputText, numberOfQuestions: numCards)
                                self.showFlashcards = true
                            } else {
                                self.presentAlert = true
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        .alert("Invalid Number", isPresented: $flashcardGenerator.showAlert) {
                            Button("OK", role: .cancel) {}
                        }
                    }
                }
                .background(
                    NavigationLink(destination: FlashcardsView(questionsAndAnswers: flashcardGenerator.questionsAndAnswers), isActive: $showFlashcards) { EmptyView() }
                )
            }
            .navigationTitle("Turn")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "line.horizontal.3")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "person.crop.circle")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
