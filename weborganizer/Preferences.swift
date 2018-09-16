//
//  Preferences.swift
//  weborganizer
//
//  Created by Bruno Vandekerkhove on 26/04/16.
//  Copyright © 2016 Koray Birand. All rights reserved.
//

import Foundation

// MARK: Preferences -

// MARK: Constants

let DefaultExportDirectory = "ExportDirectory"

// MARK: Utils

func getExportDirectory() -> String {
    
    var isDirectory = ObjCBool(false)
    let configuration = UserDefaults.standard
    
    if  let preferredDirectory = configuration.url(forKey: DefaultExportDirectory) {
        
        if FileManager.default.fileExists(atPath: preferredDirectory.path, isDirectory: &isDirectory)
            && isDirectory.boolValue {
            return preferredDirectory.path
        }
    }
    
    let pathArray = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)
    return pathArray[0]
    
}

func exportToDefault() -> Bool {
    
    return true
    
}
