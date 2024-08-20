//
//  FlashcardDetailView.swift
//  Turn2
//
//  Created by Srishti Sahi on 25/07/24.
//

import Foundation
import SwiftUI

struct FlashcardDetailView: View {
    var questionsAndAnswers: [(question: String, answer: String)]
    @State var currentCardIndex: Int
    @State private var isFlipped: Bool = false
    @State private var dragAmount = CGSize.zero
    @Environment(\.presentationMode) var presentationMode

    private var question: String {
        questionsAndAnswers[currentCardIndex].question
    }

    private var answer: String {
        questionsAndAnswers[currentCardIndex].answer
    }

    var body: some View {
        VStack {
            headerView
            Spacer()
            flashcardView
                .frame(height: 500)
            Spacer()
            flipButton
            Spacer()
        }
        .padding()
        .background(Color.blue.opacity(0.2))
        .navigationTitle("Flashcards")
        .navigationBarItems(leading: backButton)
    }

    private var headerView: some View {
        HStack {
            Spacer()
            Spacer()
        }
        .padding()
    }

    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
            Text("Back")
        }
        .padding()
    }

    private var flashcardView: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.clear)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                )
                .overlay(
                    ZStack {
                        Text(question)
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .opacity(isFlipped ? 0 : 1)
                            .animation(.easeInOut(duration: 0.3), value: isFlipped)

                        Text(answer)
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .opacity(isFlipped ? 1 : 0)
                            .animation(.easeInOut(duration: 0.3), value: isFlipped)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    }
                )
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .offset(x: dragAmount.width)
                .rotationEffect(.degrees(Double(dragAmount.width / geometry.size.width) * 25), anchor: .bottom)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragAmount = value.translation
                        }
                        .onEnded { value in
                            if value.translation.width < -100 {
                                if currentCardIndex < questionsAndAnswers.count - 1 {
                                    withAnimation {
                                        currentCardIndex += 1
                                        isFlipped = false
                                    }
                                }
                            } else if value.translation.width > 100 {
                                if currentCardIndex > 0 {
                                    withAnimation {
                                        currentCardIndex -= 1
                                        isFlipped = false
                                    }
                                }
                            }
                            withAnimation {
                                dragAmount = .zero
                            }
                        }
                )
                .animation(.spring(), value: dragAmount)
                .onTapGesture {
                    withAnimation {
                        isFlipped.toggle()
                    }
                }
                .padding()
        }
    }

    private var flipButton: some View {
        Button(action: {
            withAnimation {
                isFlipped.toggle()
            }
        }) {
            Text("Turn")
                .font(.title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
        .padding(.bottom, 50)
    }
}

struct FlashcardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardDetailView(questionsAndAnswers: Array(repeating: (question: "What is Swift?", answer: "Swift is a powerful and intuitive programming language for iOS, macOS, watchOS, and tvOS."), count: 10), currentCardIndex: 0)
    }
}
