import SwiftUI

struct CalendarView: View {
    @Binding var selectedDates: Set<Date>
    @State private var currentMonth: Date = Date()
    @State private var isExpanded: Bool = false
    @State private var currentWeekStart: Date = Date()
    @State private var dragOffset: CGFloat = 0
    @State private var isAnimating: Bool = false
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private var daysOfWeek: [String] {
        calendar.shortWeekdaySymbols
    }
    
    private var datesOfWeek: [Date] {
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentWeekStart))!
        return (0..<7).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: startOfWeek)
        }
    }
    
    private var datesOfMonth: [Date] {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let startDay = calendar.component(.weekday, from: startOfMonth)
        let daysInMonth = range.count
        let daysBefore = (startDay - calendar.firstWeekday + 7) % 7
        let totalDays = daysBefore + daysInMonth
        let rows = (totalDays + 6) / 7 // Number of rows needed
        
        var days: [Date] = []
        
        // Add days from the previous month
        for i in 0..<daysBefore {
            if let date = calendar.date(byAdding: .day, value: -daysBefore + i + 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        // Add days of the current month
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        // Add days from the next month
        let remainingDays = rows * 7 - totalDays
        for i in 0..<remainingDays {
            if let date = calendar.date(byAdding: .day, value: i + 1, to: startOfMonth.addingTimeInterval(TimeInterval(daysInMonth * 86400))) {
                days.append(date)
            }
        }
        
        return days
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Month and Year button in the top-left with arrow buttons on the right
            HStack {
                Button(action: { isExpanded.toggle() }) {
                    Text("\(currentMonth, formatter: monthFormatter)")
                        .font(.headline)
                        .padding()
                }
                Spacer()
                HStack {
                    Button(action: { changeMonth(-1) }) {
                        Image(systemName: "chevron.left")
                            .padding(.horizontal)
                    }
                    Button(action: { changeMonth(1) }) {
                        Image(systemName: "chevron.right")
                            .padding(.horizontal)
                    }
                }
                .padding()
            }
            
            // Weekday headers (displayed only in full month view)
            //if isExpanded {
                HStack {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                            .font(.subheadline)
                    }
                }
                .padding(.horizontal, 10)
            //}
            
            // Display either the full month or a single week based on isExpanded state
            if isExpanded {
                // Full month view
                let columns = [GridItem(.adaptive(minimum: 40))]
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(datesOfMonth, id: \.self) { date in
                        Button(action: {
                            toggleDate(date)
                        }) {
                            Text("\(calendar.component(.day, from: date))")
                                .frame(width: 40, height: 40)
                                .background(selectedDates.contains(date) ? Color.blue : Color.clear)
                                .foregroundColor(currentDate(date) ? Color.blue : (selectedDates.contains(date) ? Color.white : Color.black))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding()
            } else {
                // Single week view with swipe animation
                HStack(spacing: 10) {
                    ForEach(datesOfWeek, id: \.self) { date in
                        Button(action: {
                            toggleDate(date)
                        }) {
                            VStack {
                                //Text(daysOfWeek[calendar.component(.weekday, from: date) - 1])
                                Text("\(calendar.component(.day, from: date))")
                            }
                            .frame(width: 40, height: 40)
                            .background(selectedDates.contains(date) ? Color.blue : Color.clear)
                            .foregroundColor(currentDate(date) ? Color.blue : (selectedDates.contains(date) ? Color.white : Color.black))
                            .clipShape(Circle())
                        }
                    }
                }
                .padding()
                .offset(x: dragOffset)
                .animation(.easeInOut(duration: 0.3), value: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            if value.translation.width < -50 {
                                changeWeek(1)
                            } else if value.translation.width > 50 {
                                changeWeek(-1)
                            }
                            withAnimation {
                                dragOffset = .zero
                            }
                        }
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Sticking to the top
        .background(Color.white) // Optional: Add a background color if needed
        .onAppear {
            updateDisplayedDates()
        }
    }
    
    private func changeMonth(_ value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func changeWeek(_ value: Int) {
        if let newWeekStart = calendar.date(byAdding: .weekOfYear, value: value, to: currentWeekStart) {
            currentWeekStart = newWeekStart
        }
    }
    
    private func toggleDate(_ date: Date) {
        if selectedDates.contains(date) {
            selectedDates.remove(date)
        } else {
            selectedDates.insert(date)
        }
    }
    
    private func currentDate(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: Date())
    }
    
    private func updateDisplayedDates() {
        // Optionally, update any state or perform actions when dates are updated
    }
    
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
}

struct ContentView: View {
    @State private var selectedDates = Set<Date>()
    
    var body: some View {
        VStack {
            CalendarView(selectedDates: $selectedDates)
                .frame(height: 400)
            
            Text("Selected Dates:")
                .font(.headline)
                .padding(.top)
            
            List(Array(selectedDates).sorted(), id: \.self) { date in
                Text("\(date, formatter: dateFormatter)")
                    .swipeActions {
                        Button(role: .destructive) {
                            removeDate(date)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .padding()
    }
    
    private func removeDate(_ date: Date) {
        selectedDates.remove(date)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
