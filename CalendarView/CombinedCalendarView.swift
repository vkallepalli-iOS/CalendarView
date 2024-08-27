import SwiftUI

struct ContentView3: View {
    @State private var selectedSegment = 0

    var body: some View {
        VStack {
            Picker("Select View", selection: $selectedSegment) {
                Text("Multi-Date Select").tag(0)
                Text("Date Range").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            
            
            if selectedSegment == 0 {
                ContentView()
            } else {
                ContentView2()
            }
        }
        .padding()
    }
}
