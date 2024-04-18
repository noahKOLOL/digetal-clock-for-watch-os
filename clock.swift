import SwiftUI

struct RainbowClock: View {
    @State private var currentTime = Date()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // Update every second

    var body: some View {
        VStack {
            RainbowText(text: formattedTime(currentTime)) // Display the current time as rainbow text
                .font(.largeTitle)
                .padding()

            Spacer() // Add some space between time and rainbow
        }
        .onReceive(timer) { _ in
            currentTime = Date() // Update current time every second
        }
    }

    // Helper function to format time
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss" // Adjust the format as needed
        return formatter.string(from: date)
    }
}

struct RainbowText: View {
    let text: String
    let rainbowColors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
    @State private var colorIndex = 0

    var body: some View {
        Text(text)
            .foregroundColor(rainbowColors[colorIndex])
            .animation(.easeInOut(duration: 1)) // Smooth animation between color changes
            .onAppear {
                // Start cycling through rainbow colors when the view appears
                cycleColors()
            }
            .onChange(of: text) { _ in
                // Restart color cycling when the text changes
                colorIndex = 0
                cycleColors()
            }
    }

    private func cycleColors() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            withAnimation {
                colorIndex = (colorIndex + 1) % rainbowColors.count
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        RainbowClock()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
