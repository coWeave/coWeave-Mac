//
//  ViewController.swift
//  coWeave Mac
//
//  Created by Benoît Frisch on 20/11/2017.
//  Copyright © 2017 Benoît Frisch. All rights reserved.
//

import Cocoa
import Quartz
import AVFoundation

class ViewController: NSViewController {
    var document : Document!
    var currentPage : Int!
    var player = AVAudioPlayer()
    var currentAudio : NSData!
    var playing : Bool = false
    var audio : Bool = false
    
    @IBOutlet var image: NSImageView!
    @IBOutlet var name: NSTextField!
    @IBOutlet var previous: NSButton!
    @IBOutlet var next: NSButton!
    @IBOutlet var playAudio: NSButton!
    @IBOutlet var pageName: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image.imageScaling = .scaleProportionallyUpOrDown
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        // Fill the text view with the document's contents.
        let document = self.view.window?.windowController?.document as! Document
        if (document.title  != nil) {
            name.stringValue = document.title!
            self.document = document
            getPage(index: 0)
        }
    }
    
    func getPage(index: Int) {
        if (index < document.pages.count) {
            currentPage = index
            let p = self.document.pages[index] as! [String: AnyObject]
            let number = p[Document.Keys.number.rawValue] as! Int16
            let title = p[Document.Keys.title.rawValue] as? String
            let audio = p[Document.Keys.audio.rawValue] as? NSData
            let imageData = p[Document.Keys.image.rawValue] as? NSData
            if (imageData != nil) {
                image.image =  NSImage(data: imageData! as Data)
            }
            if (audio != nil) {
                self.currentAudio = audio
            }
            pageName.stringValue = (title != "none") ? title! : "Page \(number)"
        
            self.next.isEnabled = (index+1 < document.pages.count);
            self.previous.isEnabled = (index > 0);
            self.playAudio.isEnabled = audio != nil;
            self.audio = audio != nil
        }
        
    }
    
    @IBAction func playAudioAction(_ sender: Any) {
        print("audio")
        if audio && !playing { // if sound recorded, play it.
            print("audio")
            let format = DateFormatter()
            format.dateFormat="yyyy-MM-dd-HH-mm-ss"
            let currentFileName = "audio-page-\(format.string(from: Date())).m4a"
            print(currentFileName)
            
            let documentsDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            
            do {
                try currentAudio?.write(to: documentsDirectory.appendingPathComponent(currentFileName), options: .atomic)
            } catch {}
            
            do {
                self.player = try AVAudioPlayer(contentsOf: documentsDirectory.appendingPathComponent(currentFileName))
                player.delegate = self
                player.prepareToPlay()
                player.volume = 1.0
                self.playAudio.title = "Stop playing"
                self.playing = true
                player.play()
            } catch {
                print(error.localizedDescription)
            }
            return
        }
        if playing {
            print("stopping")
            self.player.stop()
            self.playing = false
            self.playAudio.title = "Play audio"
            return
        }
    }
    
    @IBAction func prevPage(_ sender: Any) {
        print("prev")
        self.player.stop()
        self.playAudio.title = "Play audio"
        getPage(index: currentPage-1)
    }
    
    @IBAction func nextPage(_ sender: Any) {
        print("next")
        self.player.stop()
        self.playAudio.title = "Play audio"
        getPage(index: currentPage+1)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


// MARK: AVAudioPlayerDelegate
extension ViewController : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("\(#function)")
        print("finished playing \(flag)")
        self.playAudio.title = "Play audio"
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("\(#function)")
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
}


