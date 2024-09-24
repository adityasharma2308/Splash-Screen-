//
//  ContentView.swift
//  Spash-Screen
//
//  Created by Aditya Sharma on 24/09/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var displayedText: String = ""
    @State private var fullText: String = "Hard Copy"
    @State private var currentIndex: Int = 0
    @State private var backgroundColor: Color = .green
    @State private var colorIndex: Int = 0
    @State private var circlePosition: CGFloat = 0
    @State private var isReversing: Bool = false
    
    let backgroundColors: [Color] = [.green, .blue, .orange, .purple, .pink]
    
    var body: some View {
        ZStack {
            // Background with smooth color transition
            backgroundColor
                .ignoresSafeArea()
            
            VStack {
                Spacer() // Pushes the text and circle to the center vertically

                // GeometryReader to dynamically get the width of the text
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Text(displayedText)
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.pink)
                                .background(
                                    GeometryReader { textGeometry in
                                        Color.clear
                                            .onChange(of: displayedText) { _ in
                                                // Update circle position based on text width
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    circlePosition = textGeometry.size.width
                                                }
                                            }
                                    }
                                )
                            
                            // Moving circle that follows the text reveal
                            Circle()
                                .fill(Color.pink)
                                .frame(width: 16, height: 16)
                                .offset(x: 5) // Small gap between text and circle
                        }
                        .frame(width: geometry.size.width, alignment: .center) // Align text and circle at the center horizontally
                    }
                }
                .frame(height: 60) // Restrict the height of GeometryReader so the text and circle are centered properly

                Spacer() // Pushes the text and circle to the center vertically
            }
            .onAppear {
                startTextAnimation()
                startBackgroundColorAnimation()
            }
        }
    }
    
    // Function to reveal characters one by one and then reverse
    func startTextAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            if !isReversing {
                if currentIndex < fullText.count {
                    let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
                    displayedText.append(fullText[index])
                    currentIndex += 1
                } else {
                    isReversing = true // Start reversing when the text is fully displayed
                }
            } else {
                if currentIndex > 0 {
                    currentIndex -= 1
                    displayedText = String(fullText.prefix(currentIndex))
                } else {
                    isReversing = false // Stop reversing when the text is fully removed and start again
                }
            }
        }
    }
    
    // Function to smoothly transition background color
    func startBackgroundColorAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1.7, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 1.7)) {
                backgroundColor = backgroundColors[colorIndex]
                colorIndex = (colorIndex + 1) % backgroundColors.count // Cycle through colors
            }
        }
    }
}
#Preview{
    SplashScreenView()
}
