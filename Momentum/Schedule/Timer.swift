import SwiftUI
import EventKit

struct Time: View {
    @State private var selectedDate = Date()
    @State private var isModalPresented = false
    @State private var eventsForDay: [EKEvent] = []
    @State private var calendarAccessGranted = false

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
            .navigationTitle("24-Hour View")
            .sheet(isPresented: $isModalPresented) {
                ModalView(
                    selectedDate: selectedDate,
                    events: $eventsForDay,
                    addEvent: addEvent
                )
            }
            .onAppear {
                requestCalendarAccess()
            }
        }
    }

    // Request Calendar Access
    func requestCalendarAccess() {
        let eventStore = EKEventStore()
        eventStore.requestFullAccessToEvents() { granted, _ in
            DispatchQueue.main.async {
                calendarAccessGranted = granted
                if granted {
                    fetchEvents(for: selectedDate)
                }
            }
        }
    }

    // Fetch Events for a Specific Date
    func fetchEvents(for date: Date) {
        guard calendarAccessGranted else { return }

        let eventStore = EKEventStore()
        let calendar = Calendar.current

        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)

        let predicate = eventStore.predicateForEvents(withStart: startOfDay, end: endOfDay ?? startOfDay, calendars: nil)
        eventsForDay = eventStore.events(matching: predicate)
    }

    // Add Event to Calendar
    func addEvent(title: String, hour: Int, minute: Int, durationSeconds: Int) {
        guard calendarAccessGranted else { return }

        let eventStore = EKEventStore()
        let calendar = Calendar.current

        let startOfDay = calendar.startOfDay(for: selectedDate)
        let eventStart = calendar.date(byAdding: DateComponents(hour: hour, minute: minute), to: startOfDay)
        let eventEnd = calendar.date(byAdding: .second, value: durationSeconds, to: eventStart!)

        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = eventStart
        event.endDate = eventEnd
        event.calendar = eventStore.defaultCalendarForNewEvents

        do {
            try eventStore.save(event, span: .thisEvent)
            fetchEvents(for: selectedDate) // Refresh events after adding
        } catch {
            print("Error saving event: \(error.localizedDescription)")
        }
    }

    struct ModalView: View {
        var selectedDate: Date
        @Binding var events: [EKEvent]
        var addEvent: (String, Int, Int, Int) -> Void

        @State private var selectedHour: Int?
        @State private var newEventTitle = ""
        @State private var eventDuration = 3600

        var body: some View {
            VStack {
                Text("Timeline for \(formattedDate(selectedDate))")
                    .font(.headline)
                    .padding()

                ScrollView {
                    VStack {
                        ForEach(0..<24, id: \.self) { hour in
                            HourRow(hour: hour, events: eventsForHour(hour: hour), onTap: {
                                selectedHour = hour
                            })
                        }
                    }
                }
                .padding()

                Divider()

                if let hour = selectedHour {
                    VStack {
                        Text("Adding Event at \(hour):00")
                            .font(.headline)
                            .padding()

                        TextField("Event Title", text: $newEventTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Picker("Duration (Minutes)", selection: $eventDuration) {
                            ForEach([15, 30, 45, 60, 120], id: \.self) { duration in
                                Text("\(duration) min").tag(duration * 60)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()

                        Button("Add Event") {
                            addEvent(newEventTitle, hour, 0, eventDuration)
                            selectedHour = nil // Reset selection
                            newEventTitle = "" // Clear input
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }

        func eventsForHour(hour: Int) -> [EKEvent] {
            let calendar = Calendar.current
            return events.filter { event in
                let eventHour = calendar.component(.hour, from: event.startDate)
                return eventHour == hour
            }
        }

        func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
    }

    struct HourRow: View {
        let hour: Int
        let events: [EKEvent]
        let onTap: () -> Void

        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(hour):00")
                        .font(.caption)
                        .bold()
                        .padding(.bottom, 2)

                    Spacer()

                    Button(action: onTap) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.blue)
                    }
                }

                if events.isEmpty {
                    Text("No Events")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    ForEach(events, id: \.eventIdentifier) { event in
                        HStack {
                            Text(event.title)
                                .font(.subheadline)
                                .lineLimit(1)
                            Spacer()
                            Text("\(formattedTime(event.startDate)) - \(formattedTime(event.endDate))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding(.vertical, 5)
        }

        func formattedTime(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    }
}

#Preview {
    Time()
}

