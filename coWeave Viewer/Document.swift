/**
 * This file is part of coWeave-Viewer.
 *
 * Copyright (c) 2017-2018 Benoît FRISCH
 *
 * coWeave-Viewer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * coWeave-Viewer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with coWeave-Viewer If not, see <http://www.gnu.org/licenses/>.
 */

import Cocoa

class Document: NSDocument {
    // MARK: Keys

    enum Keys: String {
        case addedDate = "addedDate"
        case modifyDate = "modifyDate"
        case name = "name"
        case template = "template"
        case firstPage = "firstPage"
        case lastPage = "lastPage"
        case pages = "pages"
        case user = "user"
        case group = "group"
        case image = "image"
        case next = "next"
        case previous = "previous"
        case audio = "audio"
        case number = "number"
        case title = "title"
        case document = "document"
        case page = "page"

    }

    var title: String!
    var modifyDate: NSDate!
    var pages: [NSDictionary]!


    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from url: URL, ofType typeName: String) throws {
        // 1
        guard let dictionary = NSDictionary(contentsOf: url),
              let doc = dictionary as? [String: AnyObject],
              let name = doc[Keys.name.rawValue] as? String,
              let addedDate = doc[Keys.addedDate.rawValue] as? NSDate,
              let modifyDate = doc[Keys.modifyDate.rawValue] as? NSDate,
              let template = doc[Keys.template.rawValue] as? Bool,
              let user = doc[Keys.user.rawValue] as? String,
              let group = doc[Keys.group.rawValue] as? String,
              let pages = doc[Keys.pages.rawValue] as? [NSDictionary]
                else {
            return
        }

        self.title = (user == "none") ? name : "\(name) - \(user) (\(group))"
        self.modifyDate = modifyDate
        self.pages = pages
    }


}

