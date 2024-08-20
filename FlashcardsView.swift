//
//  FlashcardsView.swift
//  Turn2
//
//  Created by Srishti Sahi on 25/07/24.
//

import Foundation
import SwiftUI

struct FlashcardsView: View {
    var questionsAndAnswers: [(question: String, answer: String)]
    @State private var deckTitle: String = "Untitled"
    @State private var editingTitle: Bool = false

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            HStack {
                if editingTitle {
                    TextField("Enter title", text: $deckTitle, onCommit: {
                        self.editingTitle = false
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                } else {
                    Text(deckTitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .onTapGesture {
                            self.editingTitle = true
                        }
                }

                Spacer()

                Button(action: {
                    self.editingTitle.toggle()
                }) {
                    Image(systemName: editingTitle ? "checkmark.circle.fill" : "pencil")
                        .imageScale(.large)
                        .font(.title)
                }
                .padding()
            }
            .padding()

            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(0..<questionsAndAnswers.count, id: \.self) { index in
                        NavigationLink(destination: FlashcardDetailView(questionsAndAnswers: questionsAndAnswers, currentCardIndex: index)) {
                            Rectangle()
                                .frame(width: 150, height: 200)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .overlay(
                                    Text("Card \(index + 1)")
                                        .foregroundColor(.black)
                                )
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(deckTitle)
        .navigationBarItems(leading: Button(action: {}) {
            Image(systemName: "line.horizontal.3")
        }, trailing: Button(action: {}) {
            Image(systemName: "magnifyingglass")
        })
    }
}

struct FlashcardsView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardsView(questionsAndAnswers: Array(repeating: (question: "Question?", answer: "Answer"), count: 10))
    }
}
