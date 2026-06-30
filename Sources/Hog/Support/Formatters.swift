import Foundation

enum Formatters {
    static func cpu(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(1))) + "%"
    }

    static func relativeSampleTime(_ date: Date?) -> String {
        guard let date else { return "Not sampled yet" }
        let seconds = max(0, Int(Date().timeIntervalSince(date)))

        if seconds < 2 {
            return "Updated now"
        }

        return "Updated \(seconds)s ago"
    }
}
