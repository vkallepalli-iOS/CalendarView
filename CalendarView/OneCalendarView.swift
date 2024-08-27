import SwiftUI
import UIKit

struct CalendarView2: UIViewRepresentable {
    @Binding var selectedDates: Set<Date>
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    @Binding var selectionMode: SelectionMode
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.selectionBehavior = UICalendarSelectionMultiDate(delegate: context.coordinator)
        calendarView.calendar = Calendar.current
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        guard let selectionBehavior = uiView.selectionBehavior as? UICalendarSelectionMultiDate else { return }
        
        // Update the selection behavior based on the mode
        if selectionMode == .range, let start = startDate, let end = endDate {
            let rangeDates = generateDates(from: start, to: end)
            
            let rangeComponents = Array(rangeDates).map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
            selectionBehavior.setSelectedDates(rangeComponents, animated: true)
        } else { // Multi-date mode
            
        }
        
        let selectedComponents = Array(selectedDates).map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
        selectionBehavior.setSelectedDates(selectedComponents, animated: true)
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
            
            if parent.selectionMode == .range {
                handleRangeSelection(for: date)
            } else { // Multi-date mode
                parent.selectedDates.insert(date)
            }
        }
        
        func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents?) {
            guard let date = dateComponents?.date else { return }
            
            if parent.selectionMode == .range {
                handleRangeDeselection(for: date)
            } else { // Multi-date mode
                parent.selectedDates.remove(date)
            }
        }
        
        private func handleRangeSelection(for date: Date) {
            if let start = parent.startDate {
                if date < start {
                    parent.startDate = date
                    parent.endDate = nil
                    parent.selectedDates = Set([date])
                } else {
                    parent.endDate = date
                    parent.selectedDates = generateDates(from: start, to: date).union(parent.selectedDates)
                }
            } else {
                parent.startDate = date
                parent.selectedDates = Set([date])
            }
        }
        
        private func handleRangeDeselection(for date: Date) {
            parent.selectedDates.remove(date)
            
            if let start = parent.startDate, let end = parent.endDate {
                if date == start {
                    parent.startDate = nil
                    parent.selectedDates = end < date ? Set() : generateDates(from: end, to: end).union(parent.selectedDates)
                } else if date == end {
                    parent.endDate = nil
                    parent.selectedDates = start > date ? Set() : generateDates(from: start, to: start).union(parent.selectedDates)
                } else {
                    parent.selectedDates = generateDates(from: start, to: end).subtracting([date]).union(parent.selectedDates)
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

enum SelectionMode {
    case multiDate
    case range
}

struct ContentView2: View {
    @State private var selectedDates = Set<Date>()
    @State private var startDate: Date?
    @State private var endDate: Date?
    @State private var selectionMode: SelectionMode = .multiDate
    
    var body: some View {
        VStack {
            Picker("Select Mode", selection: $selectionMode) {
                Text("Multi Date").tag(SelectionMode.multiDate)
                Text("Range").tag(SelectionMode.range)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            CalendarView2(selectedDates: $selectedDates, startDate: $startDate, endDate: $endDate, selectionMode: $selectionMode)
                .frame(height: 400)
                .onChange(of: selectionMode) { newMode in
                    // Handle mode change
                    if newMode == .range {
                        if let startDate = self.startDate, let endDate = self.endDate {
                            self.selectedDates = generateDates(from: startDate, to: endDate)
                        }
                    }
                }
            
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
        
        if let startDate = startDate, let endDate = endDate {
            if date == startDate {
                self.startDate = nil
                self.selectedDates = endDate > date ? Set([endDate]) : Set()
            } else if date == endDate {
                self.endDate = nil
                self.selectedDates = startDate < date ? Set([startDate]) : Set()
            } else {
                self.selectedDates = generateDates(from: startDate, to: endDate).subtracting([date]).union(selectedDates)
            }
        } else if date == startDate {
            self.startDate = nil
            self.selectedDates = Set()
        }
        
        // Update the calendar view to reflect changes
        if let startDate = self.startDate, let endDate = self.endDate {
            self.selectedDates = generateDates(from: startDate, to: endDate).union(selectedDates)
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

