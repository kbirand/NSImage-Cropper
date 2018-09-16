//
//  WindowController.swift
//  weborganizer
//
//  Created by Bruno Vandekerkhove on 26/04/16.
//  Copyright © 2016 Koray Birand. All rights reserved.
//

import Cocoa

// MARK: Window Controller -

class WindowController: NSWindowController {
    
    // MARK: Interface
    
    override func awakeFromNib() {
        
        window?.titleVisibility = .hidden
        window?.titlebarAppearsTransparent = true
        window?.isMovableByWindowBackground = true
        
    }
    
}
