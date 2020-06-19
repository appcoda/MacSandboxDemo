//
//  ViewController.swift
//  AppNotaryAndDistrib
//
//  Created by Andrew Jaffee on 5/20/20.
/*
 
 Copyright (c) 2020 Andrew L. Jaffee, microIT Infrastructure, LLC, and
 iosbrain.com.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
*/

import Cocoa

class ViewController: NSViewController {
    
    // MARK: Instance properties
    
    var userSelectedFolderURL: URL?
    
    // MARK: ViewController delegate methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // MARK: User interaction
    
    /**
     We encourage the user to select a folder, like ~/Documents,
     showing their "intent" to grant our app access to that folder.
     That directory is OUTSIDE of this app's sandbox. We do this
     in preparation for allowing us to reach out of our container.
    */
    @IBAction func selectFolderBtnClicked(_ sender: Any) {
        
        let folderSelectionDialog = NSOpenPanel() // a modal dialog
        
        folderSelectionDialog.prompt = "Select"
        folderSelectionDialog.message = "Please select a folder"
        
        folderSelectionDialog.canChooseFiles = false
        folderSelectionDialog.allowedFileTypes = ["N/A"]
        folderSelectionDialog.allowsOtherFileTypes = false
        
        folderSelectionDialog.allowsMultipleSelection = false
        
        folderSelectionDialog.canChooseDirectories = true

        // open the MODAL folder selection panel/dialog
        let dialogButtonPressed = folderSelectionDialog.runModal()
        
        // if the user pressed the "Select" (affirmative or "OK")
        // button, then they've probably chosen a folder
        if dialogButtonPressed == NSApplication.ModalResponse.OK {
            
            if folderSelectionDialog.urls.count == 1 {
                
                if let url = folderSelectionDialog.urls.first {
                    
                    // if the user doesn't select anything, then
                    // the URL "file:///" is returned, which we ignore
                    if url.absoluteString != "file:///" {
                        
                        // save the user's selection so that we can
                        // access the folder they specified (in Part II)
                        self.userSelectedFolderURL = url
                        print("User selected folder: \(url)")
                        
                    } else {
                        print("User did not select a folder: file:///")
                    }
                    
                } // end if let url = folderSelectionDialog.urls.first {
                
            } else {
                
                print("User did not select a folder")
                
            } // end if folderSelectionDialog.urls.count
            
        } else { // user clicked on "Cancel"
            
            print("User cancelled folder selection panel")
            
        } // end if dialogButtonPressed == NSApplication.ModalResponse.OK

    } // end func selectFolderBtnClicked
    
    @IBAction func selectFullDiskAccessBtnClicked(_ sender: Any) {
        
        // we use an Apple-specific URL to open System Preferences
        let url = URL.init(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")
        // we present System Preferences for "Full Disk Access" to the user
        NSWorkspace.shared.open(url!)

    }
    
    @IBAction func writeToFileBtnClicked(_ sender: Any) {
        
        // create the FULLY-QUALIFIED path to the file so
        // we're SURE we write OUTSIDE any container
        let url = URL(fileURLWithPath: "/Users/andrewjaffee/Documents/test.txt");
        
        // prepare text to write to the file
        let fileText = "This is text in the file";
        
        // try writing file to the non-sandboxed ~/Documents folder...
        do {
            try fileText.write(to: url, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error // ... or find out why write fails
        {
            print(error.localizedDescription)
            // write some code to recover from error
        }

    } // end func writeToFileBtnClicked
    
    @IBAction func exitBtnPressed(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
    
} // end ViewController

