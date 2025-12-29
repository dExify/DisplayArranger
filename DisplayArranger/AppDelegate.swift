//
//  AppDelegate.swift
//  DisplayArranger
//
//  Created by Ole Christian Sollid on 04/12/2025.
//


import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!
    let menuController = MenuBarController()

    func applicationDidFinishLaunching(_ notification: Notification) {

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // Set icon from SF Symbols
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "inset.filled.topleft.topright.bottomleft.bottomright.rectangle", accessibilityDescription: "Display Arranger")
            button.image?.isTemplate = true // Adapts to light/darkmode
        }
        
        statusItem.menu = menuController.buildMenu()

        // Observer for screenchanges
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenConfigurationChanged),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )

        updateVisibility()
    }

    @objc func screenConfigurationChanged() {
        updateVisibility()
    }

    func updateVisibility() {
        let hasExternal = NSScreen.screens.count > 1
        statusItem.isVisible = hasExternal
    }
}
