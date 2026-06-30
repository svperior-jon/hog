import AppKit
import SwiftUI

@MainActor
final class StatusItemController {
    private let monitor: ProcessMonitor
    private let settingsWindowController: SettingsWindowController
    private let statusItem: NSStatusItem
    private let popover = NSPopover()

    init(monitor: ProcessMonitor, settingsWindowController: SettingsWindowController) {
        self.monitor = monitor
        self.settingsWindowController = settingsWindowController
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        configureStatusItem()
        configurePopover()
        updateStatusItem()
        monitor.start()
    }

    private func configureStatusItem() {
        guard let button = statusItem.button else { return }

        button.image = HogStatusImage.make()
        button.image?.isTemplate = true
        button.imagePosition = .imageLeading
        button.target = self
        button.action = #selector(togglePopover(_:))
        button.toolTip = "Hog"
    }

    private func configurePopover() {
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 280, height: 180)
        popover.contentViewController = NSHostingController(
            rootView: HogMenuView(
                monitor: monitor,
                openSettingsAction: { [weak self] in
                    self?.openSettings()
                }
            )
            .frame(width: 280)
        )
    }

    private func updateStatusItem() {
        guard let button = statusItem.button else { return }
        button.title = ""
    }

    @objc private func togglePopover(_ sender: NSStatusBarButton) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            monitor.refreshNow()
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
        }
    }

    private func openSettings() {
        popover.performClose(nil)
        settingsWindowController.show()
    }
}

private enum HogStatusImage {
    static func make() -> NSImage {
        let size = NSSize(width: 18, height: 18)
        let image = NSImage(size: size)

        image.lockFocus()

        NSColor.labelColor.setStroke()
        NSColor.labelColor.setFill()

        let snoutRect = NSRect(x: 2.5, y: 4.5, width: 13, height: 9)
        let snoutPath = NSBezierPath(roundedRect: snoutRect, xRadius: 3.5, yRadius: 3.5)
        snoutPath.lineWidth = 1.6
        snoutPath.stroke()

        NSBezierPath(ovalIn: NSRect(x: 6.2, y: 8.0, width: 2.0, height: 2.0)).fill()
        NSBezierPath(ovalIn: NSRect(x: 9.8, y: 8.0, width: 2.0, height: 2.0)).fill()

        image.unlockFocus()
        image.isTemplate = true
        return image
    }
}
