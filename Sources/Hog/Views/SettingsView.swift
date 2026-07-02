import SwiftUI

struct SettingsView: View {
    @ObservedObject var monitor: ProcessMonitor
    @ObservedObject var loginItemController: LoginItemController

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsRow(label: "Startup") {
                Toggle("Start at Login", isOn: Binding(
                    get: { loginItemController.startsAtLogin },
                    set: { loginItemController.setStartsAtLogin($0) }
                ))
                .toggleStyle(.checkbox)
            }

            SettingsRow(label: "Refresh") {
                Picker("", selection: $monitor.refreshInterval) {
                    Text("2 seconds").tag(TimeInterval(2))
                    Text("5 seconds").tag(TimeInterval(5))
                    Text("10 seconds").tag(TimeInterval(10))
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                .frame(width: 260)
            }

            SettingsRow(label: "Threshold") {
                Stepper(
                    "\(Int(monitor.cpuThreshold))%",
                    value: $monitor.cpuThreshold,
                    in: 5...200,
                    step: 5
                )
                .monospacedDigit()
                .frame(width: 112, alignment: .trailing)
            }

            if let errorMessage = loginItemController.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 22)
        .frame(width: 440)
        .onAppear {
            loginItemController.refresh()
        }
    }
}

private struct SettingsRow<Content: View>: View {
    let label: String
    @ViewBuilder var content: Content

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Text(label)
                .font(.callout)
                .foregroundStyle(.secondary)
                .frame(width: 92, alignment: .trailing)

            content
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
