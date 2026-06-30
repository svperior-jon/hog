import SwiftUI

struct SettingsView: View {
    @ObservedObject var monitor: ProcessMonitor
    @ObservedObject var loginItemController: LoginItemController

    var body: some View {
        Form {
            Toggle("Start at Login", isOn: Binding(
                get: { loginItemController.startsAtLogin },
                set: { loginItemController.setStartsAtLogin($0) }
            ))

            Picker("Refresh interval", selection: $monitor.refreshInterval) {
                Text("2 seconds").tag(TimeInterval(2))
                Text("5 seconds").tag(TimeInterval(5))
                Text("10 seconds").tag(TimeInterval(10))
            }
            .pickerStyle(.segmented)

            if let errorMessage = loginItemController.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .frame(width: 360)
        .onAppear {
            loginItemController.refresh()
        }
    }
}
