import Foundation
import ServiceManagement

@MainActor
final class LoginItemController: ObservableObject {
    @Published private(set) var startsAtLogin = false
    @Published private(set) var errorMessage: String?

    init() {
        refresh()
    }

    func refresh() {
        startsAtLogin = SMAppService.mainApp.status == .enabled
    }

    func setStartsAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }

            errorMessage = nil
            refresh()
        } catch {
            errorMessage = error.localizedDescription
            refresh()
        }
    }
}
