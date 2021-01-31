//
//  AboutViewController.swift
//  PortButler
//
//  Created by Albin Ekblom on 2021-01-31.
//  Copyright © 2021 Albin Ekblom. All rights reserved.
//


import Cocoa

class AboutViewController: NSViewController {

    @IBOutlet weak var appNameLabel: NSTextField!
    @IBOutlet weak var appVersionLabel: NSTextField!
    @IBOutlet weak var appCopyrightLabel: NSTextField!
    @IBOutlet weak var appIconImageView: NSImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Read the app's info and reflect that content in the window's subviews:
        self.appIconImageView.image = NSApp.applicationIconImage
        if let infoDictionary = Bundle.main.infoDictionary {
            self.appNameLabel.stringValue = infoDictionary["CFBundleName"] as? String ?? ""
            self.appVersionLabel.stringValue = infoDictionary["CFBundleShortVersionString"] as? String ?? ""
            self.appCopyrightLabel.stringValue = infoDictionary["NSHumanReadableCopyright"] as? String ?? ""

            // If you add more custom subviews to display additional information
            // about your app, configure them here
        }
    }
    
    
}
