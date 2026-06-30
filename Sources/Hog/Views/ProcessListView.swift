import SwiftUI

struct ProcessListView: View {
    let processes: [ProcessSample]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if processes.isEmpty {
                Text("No active CPU consumers")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                ForEach(Array(processes.enumerated()), id: \.element.id) { index, process in
                    ProcessRow(rank: index + 1, process: process)
                }
            }
        }
    }
}

private struct ProcessRow: View {
    let rank: Int
    let process: ProcessSample

    var body: some View {
        HStack(spacing: 10) {
            Text("\(rank)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 18, alignment: .trailing)

            Text(process.name)
                .font(.callout)
                .lineLimit(1)
                .truncationMode(.middle)

            Spacer(minLength: 12)

            Text(Formatters.cpu(process.cpu))
                .font(.callout.monospacedDigit())
                .foregroundStyle(process.cpu >= 50 ? .red : .primary)
                .frame(width: 58, alignment: .trailing)
        }
        .accessibilityElement(children: .combine)
    }
}
