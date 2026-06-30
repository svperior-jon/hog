import Foundation

@MainActor
final class HogApplicationModel: ObservableObject {
    let monitor: ProcessMonitor
    let loginItemController: LoginItemController
    private let settingsWindowController: SettingsWindowController
    private let statusItemController: StatusItemController

    init() {
        monitor = ProcessMonitor()
        loginItemController = LoginItemController()
        settingsWindowController = SettingsWindowController(
            monitor: monitor,
            loginItemController: loginItemController
        )
        statusItemController = StatusItemController(
            monitor: monitor,
            settingsWindowController: settingsWindowController
        )
        monitor.start()
    }
}
