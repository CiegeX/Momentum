import SwiftUI
import Foundation

struct TimerView: View {
    @State private var timer: Foundation.Timer? // Timer instance
    @State private var timeRemaining = 0 // Remaining time in seconds
    @State private var timerRunning = false // Timer control flag

    // User input for hours, minutes, and seconds
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0

    var body: some View {
        VStack(spacing: 10) {
            

            // User input for hours, minutes, and seconds
            HStack() {
                Picker("Hours", selection: $hours) {
                    ForEach(0..<24) { Text("\($0) h") }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 80)

                Picker("Minutes", selection: $minutes) {
                    ForEach(0..<60) { Text("\($0) m") }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 80)

                Picker("Seconds", selection: $seconds) {
                    ForEach(0..<60) { Text("\($0) s") }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 80)
            }

            // Display time remaining
            Text(formatTime(timeRemaining))
                .font(.system(size: 36, weight: .bold, design: .monospaced))
                

            // Control buttons
            HStack(spacing: 20) {
                Button(timerRunning ? "Pause" : "Start") {
                    if timerRunning {
                        stopTimer()
                    } else {
                        setTimeRemaining() // Set time before starting
                        startTimer()
                    }
                }
                .padding()
                .background(timerRunning ? Color.orange : Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Reset") {
                    resetTimer()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }

    func setTimeRemaining() {
        // Convert user input into total seconds
        timeRemaining = (hours * 3600) + (minutes * 60) + seconds
    }

    func startTimer() {
        // Stop any existing timer
        stopTimer()

        // Start the timer
        timerRunning = true
        timer = Foundation.Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer() // Stop when time reaches zero
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
    }

    func resetTimer() {
        stopTimer()
        timeRemaining = 0
        hours = 0
        minutes = 0
        seconds = 0
    }

    func formatTime(_ seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: TimeInterval(seconds)) ?? "00:00:00"
    }
}

struct AdjustableTimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
