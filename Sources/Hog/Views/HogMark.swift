import SwiftUI

struct HogMark: View {
    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            let lineWidth = max(1.25, size * 0.09)

            ZStack {
                RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                    .stroke(.primary, lineWidth: lineWidth)
                    .frame(width: size * 0.86, height: size * 0.54)
                    .position(x: proxy.size.width / 2, y: proxy.size.height * 0.55)

                Circle()
                    .fill(.primary)
                    .frame(width: size * 0.13, height: size * 0.13)
                    .position(x: proxy.size.width * 0.42, y: proxy.size.height * 0.55)

                Circle()
                    .fill(.primary)
                    .frame(width: size * 0.13, height: size * 0.13)
                    .position(x: proxy.size.width * 0.58, y: proxy.size.height * 0.55)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityHidden(true)
    }
}
