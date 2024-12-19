import SwiftUI
import EventKit

struct Time: View {
    @State private var selectedDate = Date()
    @State private var isModalPresented = false

    var body: some View {
        NavigationView {
            VStack {
                TimerView()
                Spacer()

                DatePicker(
                    "Select a date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .frame(width: 350, height: 350, alignment: .center)
                .onChange(of: selectedDate) {
                    isModalPresented = true
                }
            }
            .navigationTitle("Action Tab")
            .sheet(isPresented: $isModalPresented) {
                ModalView(selectedDate: selectedDate)
            }
        }
    }

    struct ModalView: View {
        var selectedDate: Date
        @State private var hours = 0
        @State private var minutes = 0
        @State private var seconds = 0
        @State private var calendarAccessGranted = false

        var body: some View {
            VStack {
                Text("You Selected:")
                Text("\(formattedDate(selectedDate))")
                    .font(Font.custom("My Font", size: 20))

                Spacer()

                Text("Set Time Duration")
                    .font(.headline)

                HStack {
                    Picker("Hours", selection: $hours) {
                        ForEach(0..<24, id: \.self) { Text("\($0)").tag($0) }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100)

                    Picker("Minutes", selection: $minutes) {
                        ForEach(0..<60, id: \.self) { Text("\($0)").tag($0) }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100)

                    Picker("Seconds", selection: $seconds) {
                        ForEach(0..<60, id: \.self) { Text("\($0)").tag($0) }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100)
                }
                .padding()

                Button("Add to Calendar") {
                    addToCalendar()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
            }
            .padding()
            .onAppear {
                requestCalendarAccess()
            }
        }

        func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }

        func requestCalendarAccess() {
            let eventStore = EKEventStore()
            eventStore.requestFullAccessToEvents() { granted, _ in
                DispatchQueue.main.async {
                    calendarAccessGranted = granted
                }
            }
        }

        func addToCalendar() {
            guard calendarAccessGranted else {
                print("Calendar access not granted.")
                return
            }

            let eventStore = EKEventStore()
            let event = EKEvent(eventStore: eventStore)
            event.title = "Scheduled Event"
            event.startDate = selectedDate
            event.endDate = Calendar.current.date(byAdding: .second, value: (hours * 3600) + (minutes * 60) + seconds, to: selectedDate)
            event.calendar = eventStore.defaultCalendarForNewEvents

            do {
                try eventStore.save(event, span: .thisEvent)
                print("Event added to calendar.")
            } catch {
                print("Error adding event: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    Time()
}

