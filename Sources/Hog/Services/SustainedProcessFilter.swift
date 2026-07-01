import Foundation

struct SustainedProcessFilter {
    private var firstAboveThresholdAt: [Int: Date] = [:]

    mutating func update(
        samples: [ProcessSample],
        at date: Date,
        threshold: Double,
        minimumDuration: TimeInterval,
        limit: Int
    ) -> [ProcessSample] {
        let aboveThreshold = samples.filter { $0.cpu > threshold }
        let activePIDs = Set(aboveThreshold.map(\.pid))

        firstAboveThresholdAt = firstAboveThresholdAt.filter { activePIDs.contains($0.key) }

        for sample in aboveThreshold where firstAboveThresholdAt[sample.pid] == nil {
            firstAboveThresholdAt[sample.pid] = date
        }

        return aboveThreshold
            .filter { sample in
                guard let start = firstAboveThresholdAt[sample.pid] else { return false }
                return date.timeIntervalSince(start) >= minimumDuration
            }
            .sorted { lhs, rhs in
                if lhs.cpu == rhs.cpu {
                    return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
                }
                return lhs.cpu > rhs.cpu
            }
            .prefix(limit)
            .map { $0 }
    }

    mutating func reset() {
        firstAboveThresholdAt.removeAll()
    }
}
