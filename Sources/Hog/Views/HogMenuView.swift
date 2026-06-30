import AppKit
import SwiftUI

struct HogMenuView: View {
    @ObservedObject var monitor: ProcessMonitor
    var openSettingsAction: (() -> Void)?
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header

            Divider()

            if let errorMessage = monitor.snapshot.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ProcessListView(
                processes: monitor.snapshot.topProcesses,
                hasSampled: monitor.snapshot.sampledAt != nil
            )

            Divider()

            footer
        }
        .padding(12)
    }

    private var header: some View {
        HStack(spacing: 8) {
            Text("Top CPU")
                .font(.callout.weight(.semibold))

            Spacer()

            Button {
                monitor.refreshNow()
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(.borderless)
            .help("Refresh")
        }
    }

    private var footer: some View {
        HStack {
            Text(Formatters.relativeSampleTime(monitor.snapshot.sampledAt))
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()

            Button("Activity Monitor") {
                NSWorkspace.shared.openApplication(
                    at: URL(fileURLWithPath: "/System/Applications/Utilities/Activity Monitor.app"),
                    configuration: NSWorkspace.OpenConfiguration()
                )
            }

            Button("Settings") {
                if let openSettingsAction {
                    openSettingsAction()
                } else {
                    openSettings()
                }
            }
        }
        .font(.caption)
    }
}
