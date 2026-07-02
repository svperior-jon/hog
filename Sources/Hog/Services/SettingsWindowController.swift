import AppKit
import SwiftUI

@MainActor
final class SettingsWindowController {
    private let monitor: ProcessMonitor
    private let loginItemController: LoginItemController
    private var window: NSWindow?

    init(monitor: ProcessMonitor, loginItemController: LoginItemController) {
        self.monitor = monitor
        self.loginItemController = loginItemController
    }

    func show() {
        if window == nil {
            let hostingController = NSHostingController(
                rootView: SettingsView(
                    monitor: monitor,
                    loginItemController: loginItemController
                )
            )

            let settingsWindow = NSWindow(contentViewController: hostingController)
            settingsWindow.title = "Hog Settings"
            settingsWindow.styleMask = [.titled, .closable]
            settingsWindow.isReleasedWhenClosed = false
            settingsWindow.setContentSize(NSSize(width: 440, height: 190))
            settingsWindow.minSize = NSSize(width: 440, height: 190)
            settingsWindow.center()
            window = settingsWindow
        }

        NSApp.activate(ignoringOtherApps: true)
        window?.makeKeyAndOrderFront(nil)
    }
}
