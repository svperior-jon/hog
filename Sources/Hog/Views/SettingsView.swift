import SwiftUI

struct SettingsView: View {
    @ObservedObject var monitor: ProcessMonitor

    var body: some View {
        Form {
            Picker("Refresh interval", selection: $monitor.refreshInterval) {
                Text("2 seconds").tag(TimeInterval(2))
                Text("5 seconds").tag(TimeInterval(5))
                Text("10 seconds").tag(TimeInterval(10))
            }
            .pickerStyle(.segmented)
        }
        .padding(20)
        .frame(width: 360)
    }
}
