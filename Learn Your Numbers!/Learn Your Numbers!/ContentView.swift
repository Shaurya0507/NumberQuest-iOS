// Repo test edit

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Learn Your Numbers!")
                    .font(.largeTitle)
                    .bold()

                // Level buttons
                ForEach(0..<3) { row in
                    HStack {
                        ForEach(1..<4) { col in
                            let number = row * 3 + col
                            NavigationLink(destination: PracticeView(targetNumber: number)) {
                                Text("\(number)")
                                    .frame(width: 60, height: 60)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .font(.title)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}
