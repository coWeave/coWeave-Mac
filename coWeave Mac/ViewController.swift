//
//  ViewController.swift
//  coWeave Mac
//
//  Created by Benoît Frisch on 20/11/2017.
//  Copyright © 2017 Benoît Frisch. All rights reserved.
//

import Cocoa
import Quartz

class ViewController: NSViewController {
    @IBOutlet var image: NSImageView!
    @IBOutlet var name: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        // Fill the text view with the document's contents.
        let document = self.view.window?.windowController?.document as! Document
        if (document.title  != nil) {
            name.stringValue = document.title!
            image.image = NSImage(data: document.image as Data)
            image.imageScaling = .scaleProportionallyUpOrDown
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

