
import SwiftUI
import UIKit
/*
struct CalendarView2: UIViewRepresentable {
    @Binding var selectedDates: Set<Date>
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.selectionBehavior = UICalendarSelectionMultiDate(delegate: context.coordinator)
        calendarView.calendar = Calendar.current
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        guard let selectionBehavior = uiView.selectionBehavior as? UICalendarSelectionMultiDate else { return }
        
        // Convert selected dates to date components
        let selectedComponents = Array(selectedDates).map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
        selectionBehavior.setSelectedDates(selectedComponents, animated: true)
        
        // Highlight dates within the range if a range is selected
        if let start = startDate, let end = endDate {
            let rangeDates = generateDates(from: start, to: end)
            let rangeComponents = Array(rangeDates).map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
            selectionBehavior.setSelectedDates(rangeComponents, animated: true)
        }
    }
    private func generateDates(from start: Date, to end: Date) -> Set<Date> {
        var dates = Set<Date>()
        var currentDate = start
        while currentDate <= end {
            dates.insert(currentDate)
            if let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            } else {
                break
            }
        }
        return dates
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICalendarSelectionMultiDateDelegate {
        var parent: CalendarView2
        
        init(_ parent: CalendarView2) {
            self.parent = parent
        }
        
        func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents?) {
            guard let date = dateComponents?.date else { return }
            
            if let start = parent.startDate {
                if date < start {
                    parent.startDate = date
                    parent.endDate = nil
                    parent.selectedDates = Set([date])
                } else {
                    parent.endDate = date
                    parent.selectedDates = generateDates(from: start, to: date)
                }
            } else {
                parent.startDate = date
                parent.selectedDates = Set([date])
            }
        }
        
        func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents?) {
            guard let date = dateComponents?.date else { return }
            
            parent.selectedDates.remove(date)
            
            if let start = parent.startDate, let end = parent.endDate {
                if date == start {
                    parent.startDate = nil
                    parent.selectedDates = end < date ? Set() : generateDates(from: end, to: end)
                } else if date == end {
                    parent.endDate = nil
                    parent.selectedDates = start > date ? Set() : generateDates(from: start, to: start)
                } else {
                    parent.selectedDates = generateDates(from: start, to: end).subtracting([date])
                }
            } else if date == parent.startDate {
                parent.startDate = nil
                parent.selectedDates = Set()
            }
        }
        
        private func generateDates(from start: Date, to end: Date) -> Set<Date> {
            var dates = Set<Date>()
            var currentDate = start
            while currentDate <= end {
                dates.insert(currentDate)
                if let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
                    currentDate = nextDate
                } else {
                    break
                }
            }
            return dates
        }
    }
}






struct ContentView2: View {
    @State private var selectedDates = Set<Date>()
    @State private var startDate: Date?
    @State private var endDate: Date?
    
    var body: some View {
        VStack {
            CalendarView2(selectedDates: $selectedDates, startDate: $startDate, endDate: $endDate)
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
        
        // Handle range selection removal
        if let startDate = startDate, let endDate = endDate {
            if date == startDate {
                self.startDate = nil
                self.selectedDates = endDate > date ? Set([endDate]) : Set()
            } else if date == endDate {
                self.endDate = nil
                self.selectedDates = startDate < date ? Set([startDate]) : Set()
            } else {
                self.selectedDates = generateDates(from: startDate, to: endDate).subtracting([date])
            }
        } else if date == startDate {
            self.startDate = nil
            self.selectedDates = Set()
        }
        
        // Update the calendar view to reflect changes
        if let startDate = self.startDate, let endDate = self.endDate {
            self.selectedDates = generateDates(from: startDate, to: endDate)
        }
    }
    
    private func generateDates(from start: Date, to end: Date) -> Set<Date> {
        var dates = Set<Date>()
        var currentDate = start
        while currentDate <= end {
            dates.insert(currentDate)
            if let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            } else {
                break
            }
        }
        return dates
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

*/

