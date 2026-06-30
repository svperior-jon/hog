import SwiftUI

struct MenuBarLabel: View {
    let snapshot: ProcessSnapshot

    var body: some View {
        HStack(spacing: 5) {
            HogMark()
                .frame(width: 15, height: 15)

            if let leader = snapshot.leader {
                Text("\(leader.name) \(Formatters.cpu(leader.cpu))")
                    .monospacedDigit()
                    .lineLimit(1)
            }
        }
    }
}
