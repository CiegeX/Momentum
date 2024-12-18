//
//  Timer.swift
//  Momentum
//
//  Created by Auggie Dev on 12/17/24.
//

import SwiftUI

struct Timer: View {
    @State private var selectedDate = Date()
    @State private var isModalPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                HStack{
                    Text("Selected Date:")
                        .font(.headline)
                    Text(selectedDate, style: .date) // Display the selected date
                        .font(Font.custom("MY Font", size: 19))
                }
                DatePicker(
                    "Select a date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle()) // Calendar-like display
                .padding()
                .frame(width: 350 , height: 350, alignment: .center)
                .onChange(of: selectedDate) {
                    // Action for when selectedDate changes
                    isModalPresented = true
                }

                            
            }
            .navigationTitle("Action Tab")
            .sheet(isPresented: $isModalPresented) {
                       ModalView(selectedDate: selectedDate)
                   }
        }
    }
}

struct ModalView: View {
    var selectedDate: Date

    var body: some View {
        VStack {
            Text("You Selected:")
                .font(.title)
            Text("\(formattedDate(selectedDate))")
                .font(Font.custom("My Font", size: 20)
                )
            Spacer()
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

#Preview {
    Timer()
}
 
 
