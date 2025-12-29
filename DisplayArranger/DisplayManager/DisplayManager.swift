//
//  DisplayManager.swift
//  DisplayArranger
//
//  Created by Ole Christian Sollid on 04/12/2025.
//

import Foundation
import CoreGraphics


class DisplayManager {
    /**
     * Attempts to place the second active display relative to the primary display
     * using public Core Graphics configuration functions.
     * @param placement The desired relative position (.left, .right, .above, or .below).
     */
    func place(_ placement: DisplayPlacement) {
        let displays = activeDisplays()
        guard displays.count >= 2 else {
            print("Only one display found. Cant arrange")
            return
        }
        
        // The first display in the list is usually the primary display
        let primary = displays[0]
        let external = displays[1]
        
        let primaryBounds = CGDisplayBounds(primary)
        let externalBounds = CGDisplayBounds(external)
        
        var newX: CGFloat = 0
        var newY: CGFloat = 0
        
        // Calculate the new origin (top-left corner) for extra display
        switch placement {
        case .left:
            // x = -(width of external display)
            newX = -externalBounds.width
            // Center vertically relative to primary
            newY = (primaryBounds.height - externalBounds.height) / 2
            
        case .right:
            // x = (width of primary display)
            newX = primaryBounds.width
            newY = (primaryBounds.height - externalBounds.height) / 2
            
        case .above:
            newY = -externalBounds.height
            newX = (primaryBounds.width - externalBounds.width) / 2
            
        case .below:
            newY = primaryBounds.height
            newX = (primaryBounds.width - externalBounds.width) / 2
        }
        
        var configRef: CGDisplayConfigRef?
        
        // Start the config transaction
        let beginResult = CGBeginDisplayConfiguration(&configRef)
        guard beginResult == .success, let config = configRef else {
            print("CGBeginDisplayConfiguration failed: \(beginResult.rawValue)")
            return
        }
        
        // Set the new origin for the extra display
        let setResult = CGConfigureDisplayOrigin(config, external, Int32(newX), Int32(newY))
        
        if setResult == .success {
            // Commit change permanently and save to usrprefs
            let completeResult = CGCompleteDisplayConfiguration(config, .permanently)
            if completeResult == .success {
                print("Reposition complete: External display moved \(placement)")
            } else {
                print("CGCompleteDisplayConfiguration failed: \(completeResult.rawValue)")
            }
        } else {
            print("CGConfigureDisplayOrigin failed: \(setResult.rawValue)")
            // If setting the origin fails, cancel transaction
            CGCompleteDisplayConfiguration(config, .forAppOnly)
        }
    }
    
    /**
     * Gets a list of all currently active (on and connected) displays.
     * @return An array of CGDirectDisplayID for active displays.
     */
    private func activeDisplays() -> [CGDirectDisplayID] {
        var count: UInt32 = 0
        
        // Get the count of active displays
        CGGetActiveDisplayList(0, nil, &count)
        
        // Allocate space for the list
        var list = [CGDirectDisplayID](repeating: 0, count: Int(count))
        
        // Get the list of IDs
        CGGetActiveDisplayList(count, &list, &count)
        
        return list
    }
}
