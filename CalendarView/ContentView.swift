import SwiftUI
import UIKit

/*
struct CalendarView: UIViewRepresentable {
    @Binding var selectedDates: Set<Date>
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.selectionBehavior = UICalendarSelectionMultiDate(delegate: context.coordinator)
        // Set pre-populated dates
        updateSelectedDates(for: calendarView, with: selectedDates)
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        let selectionBehavior = uiView.selectionBehavior as? UICalendarSelectionMultiDate
        selectionBehavior?.selectedDates = Array(selectedDates).map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
    }
    
    private func updateSelectedDates(for calendarView: UICalendarView, with dates: Set<Date>) {
        let selectionBehavior = calendarView.selectionBehavior as? UICalendarSelectionMultiDate
        selectionBehavior?.selectedDates = dates.map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICalendarSelectionMultiDateDelegate {
        var parent: CalendarView
        
        init(_ parent: CalendarView) {
            self.parent = parent
        }
        
        func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents?) {
            guard let date = dateComponents?.date else { return }
            parent.selectedDates.insert(date)
        }
        
        func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents?) {
            guard let date = dateComponents?.date else { return }
            parent.selectedDates.remove(date)
        }
    }
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
    
    func dateFromMMDDYYYY(_ dateString: String) -> DateComponents? {
        // Define the date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyyyy" // Define the input format
        
        // Convert the string to a Date object
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date format")
            return nil
        }
        
        // Extract the date components
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        return components
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
*/
