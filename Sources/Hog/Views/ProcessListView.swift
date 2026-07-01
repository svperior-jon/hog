import SwiftUI

struct ProcessListView: View {
    let processes: [ProcessSample]
    let hasSampled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if processes.isEmpty {
                Text("Hog has no truffles")
                    .font(.caption)
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
                .frame(width: 14, alignment: .trailing)

            Text(process.name)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.middle)

            Spacer(minLength: 12)

            Text(Formatters.cpu(process.cpu))
                .font(.caption.monospacedDigit())
                .foregroundStyle(process.cpu >= 50 ? .red : .primary)
                .frame(width: 52, alignment: .trailing)
        }
        .accessibilityElement(children: .combine)
    }
}
