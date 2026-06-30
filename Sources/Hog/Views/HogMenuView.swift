import AppKit
import SwiftUI

struct HogMenuView: View {
    @ObservedObject var monitor: ProcessMonitor
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header

            Divider()

            if let errorMessage = monitor.snapshot.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ProcessListView(processes: monitor.snapshot.topProcesses)

            Divider()

            footer
        }
        .padding(14)
    }

    private var header: some View {
        HStack(spacing: 9) {
            HogMark()
                .frame(width: 18, height: 18)

            VStack(alignment: .leading, spacing: 2) {
                Text("Hog")
                    .font(.headline)
                Text("Top CPU consumers")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

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
                openSettings()
            }
        }
        .font(.caption)
    }
}
