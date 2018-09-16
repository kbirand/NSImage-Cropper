//
//  ViewController.swift
//  weborganizer
//
//  Created by Koray Birand on 25/04/16.
//  Copyright © 2016 Koray Birand. All rights reserved.
//

import Cocoa

// MARK: View Controller -

class ViewController: NSViewController, NSSplitViewDelegate, NSControlTextEditingDelegate, ImageViewDelegate {

    @IBOutlet var mainView: NSView!
    @IBOutlet weak var imageView: ImageView!
    
    // MARK: Interface
    
    @IBOutlet weak var oldWidthField: NSTextField!
    @IBOutlet weak var oldHeightField: NSTextField!
    
    @IBOutlet weak var widthField: NSTextField!
    @IBOutlet weak var heightField: NSTextField!
    @IBOutlet weak var compressionField: NSTextField!
    @IBOutlet weak var selectionSizeField: NSTextField!
    
    @IBOutlet weak var saveButton: NSButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        imageView.delegate = self
        oldWidthField.stringValue = "\(Int(imageView.image!.size.width))"
        oldHeightField.stringValue = "\(Int(imageView.image!.size.height))"
        widthField.isEnabled = false
        heightField.isEnabled = false
        selectionSizeField.stringValue = "No selection"
        
    }
    
    func control(_ control: NSControl, textView: NSTextView, completions words: [String], forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [String] {
        
        return []
        
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        
        if  let selectionSize = imageView.selectionSize(),
            let sender = obj.object {
            
            if selectionSize.height > 0 {
                
                let aspectRatio = (Double(Int(selectionSize.width)) / Double(Int(selectionSize.height)))
                
                if sender as! NSObject == widthField {
                    
                    if aspectRatio != 0 {
                        heightField.integerValue = Int(widthField.doubleValue / aspectRatio)
                    }
                    
                }
                else if sender as! NSObject == heightField {
                    
                    widthField.integerValue = Int(heightField.doubleValue * aspectRatio)
                    
                }
                
            }
            
        }
        
    }
    
    // MARK: Actions
    
//    @IBAction func saveImage(_ sender: AnyObject) {
//        
//        saveButton.isEnabled = false
//        
//        if exportToDefault() {
//            
//            let defaultDirectory = getExportDirectory()
//            exportToDirectory(defaultDirectory, name: "Image")
//            
//        }
//        else {
//            
//            let panel = NSSavePanel()
//            panel.nameFieldStringValue = "Image"
//            panel.beginSheetModal(for: self.view.window!, completionHandler: {
//                (result: Int) in
//                
//                if  result == NSFileHandlingPanelOKButton,
//                    let URL = panel.url?.deletingPathExtension() {
//                    
//                    self.exportToDirectory(URL.deletingLastPathComponent().path, name: URL.lastPathComponent)
//                    
//                }
//                else {
//                    NSSound.beep()
//                }
//                
//            })
//            
//        }
//        
//        if !rendering {
//            saveButton.isEnabled = true
//        }
//        
//    }
    
    @objc var rendering = false
    
    fileprivate func exportToDirectory(_ path: String, name: String) {
        
        if rendering {
            return
        }
        
        rendering = true
        
        let pathExtension = "jpeg"
        
        var i = 0
        var filename = name + "." + pathExtension
        while FileManager.default.fileExists(atPath: path + "/" + filename) {
            filename = name + "-\(i)." + pathExtension
            i = i+1
        }
        
        // Swift.print(path + "/" + filename) // Print output file
        
        let croppedSize = NSMakeSize(CGFloat(widthField.floatValue), CGFloat(heightField.floatValue))
        let compressionFactor = 1.0 - compressionField.floatValue / 10.0
        if let data = imageView.croppedImageData(croppedSize, compression: compressionFactor) {
            try? data.write(to: URL(fileURLWithPath: path + "/" + filename), options: [])
        }
        else {
            NSSound.beep()
        }
        
        rendering = false
        
    }
        
    // MARK: Image View
    
    @objc func imageViewDidChangeImage(_ imageView: ImageView) {
        
        oldWidthField.stringValue = "\(Int(imageView.image!.size.width))"
        oldHeightField.stringValue = "\(Int(imageView.image!.size.height))"
        
    }
    
    @objc func imageViewDidChangeSelection(_ imageView: ImageView) {
        
        if let selectionSize = imageView.selectionSize() {
            
            widthField.stringValue = "\(Int(selectionSize.width))"
            heightField.stringValue = "\(Int(selectionSize.height))"
            selectionSizeField.stringValue = "\(Int(selectionSize.width)) x \(Int(selectionSize.height))"
            widthField.isEnabled = true
            heightField.isEnabled = true
            
        }
        else {
            
            widthField.isEnabled = false
            heightField.isEnabled = false
            selectionSizeField.stringValue = "No selection"
            
        }
        
    }
    
    // MARK: Split View
    
    @IBOutlet var splitView: NSSplitView!
    
    func splitView(_ splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
        
        if view == splitView.subviews.first {
            return true
        }
        
        return false
        
    }
    
    func splitView(_ splitView: NSSplitView, shouldHideDividerAt dividerIndex: Int) -> Bool {
        
        return true
        
    }
    
    func splitView(_ splitView: NSSplitView, effectiveRect proposedEffectiveRect: NSRect, forDrawnRect drawnRect: NSRect, ofDividerAt dividerIndex: Int) -> NSRect {
        
        return NSZeroRect
        
    }

}

