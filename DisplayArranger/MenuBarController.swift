//
//  MenuBarController.swift
//  DisplayArranger
//
//  Created by Ole Christian Sollid on 04/12/2025.
//
import AppKit
import ServiceManagement

class MenuBarController: NSObject {
    let displayManager = DisplayManager()
    
    func buildMenu() -> NSMenu {
        let menu = NSMenu()
        
        // LEFT
        let leftItem = NSMenuItem(
            title: "Place screen to the left",
            action: #selector(placeLeft),
            keyEquivalent: ""
        )
        leftItem.target = self
        menu.addItem(leftItem)
        
        // RIGHT
        let rightItem = NSMenuItem(
            title: "Place screen to the right",
            action: #selector(placeRight),
            keyEquivalent: ""
        )
        rightItem.target = self
        menu.addItem(rightItem)
        
        // ABOVE
        let aboveItem = NSMenuItem(
            title: "Place screen above",
            action: #selector(placeAbove),
            keyEquivalent: ""
        )
        aboveItem.target = self
        menu.addItem(aboveItem)
        
        // BELOW
        let belowItem = NSMenuItem(
            title: "Place screen below",
            action: #selector(placeBelow),
            keyEquivalent: ""
        )
        belowItem.target = self
        menu.addItem(belowItem)
        
        // Separator
        menu.addItem(NSMenuItem.separator())
        
        // RUN AT STARTUP
        let startupItem = NSMenuItem(
            title: "Run at startup",
            action: #selector(toggleStartup),
            keyEquivalent: ""
        )
        startupItem.target = self
        startupItem.state = isLaunchAtStartupEnabled() ? .on : .off
        menu.addItem(startupItem)
        
        // QUIT
        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(quit),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)
        
        return menu
    }
    
    // MARK: - Actions
    
    @objc func placeLeft() {
        displayManager.place(.left)
    }
    
    @objc func placeRight() {
        displayManager.place(.right)
    }
    
    @objc func placeAbove() {
        displayManager.place(.above)
    }
    
    @objc func placeBelow() {
        displayManager.place(.below)
    }
    
    @objc func toggleStartup(_ sender: NSMenuItem) {
        if isLaunchAtStartupEnabled() {
            disableLaunchAtStartup()
            sender.state = .off
        } else {
            enableLaunchAtStartup()
            sender.state = .on
        }
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }
    
    // MARK: - Launch at startup helpers
    
    private func isLaunchAtStartupEnabled() -> Bool {
        if #available(macOS 13.0, *) {
            return SMAppService.mainApp.status == .enabled
        } else {
            // Fallback for older macOS versions
            return UserDefaults.standard.bool(forKey: "launchAtStartup")
        }
    }
    
    private func enableLaunchAtStartup() {
        if #available(macOS 13.0, *) {
            do {
                try SMAppService.mainApp.register()
                print("✅ Launch at startup enabled")
            } catch {
                print("❌ Failed to enable launch at startup: \(error)")
            }
        } else {
            // Fallback for older macOS versions
            UserDefaults.standard.set(true, forKey: "launchAtStartup")
        }
    }
    
    private func disableLaunchAtStartup() {
        if #available(macOS 13.0, *) {
            do {
                try SMAppService.mainApp.unregister()
                print("Launch at startup disabled")
            } catch {
                print("Failed to disable launch: \(error)")
            }
        } else {
            // Fallback for older macOS versions
            UserDefaults.standard.set(false, forKey: "launchAtStartup")
        }
    }
}
