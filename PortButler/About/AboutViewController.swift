//
//  AboutViewController.swift
//  PortButler
//
//  Created by Albin Ekblom on 2021-01-31.
//  Copyright © 2021 Albin Ekblom. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {
    @IBOutlet var appNameLabel: NSTextField!
    @IBOutlet var appVersionLabel: NSTextField!
    @IBOutlet var appCopyrightLabel: NSTextField!
    @IBOutlet var appIconImageView: NSImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Read the app's info and reflect that content in the window's subviews:
        appIconImageView.image = NSApp.applicationIconImage
        if let infoDictionary = Bundle.main.infoDictionary {
            appNameLabel.stringValue = infoDictionary["CFBundleName"] as? String ?? ""
            appVersionLabel.stringValue = infoDictionary["CFBundleShortVersionString"] as? String ?? ""
            appCopyrightLabel.stringValue = infoDictionary["NSHumanReadableCopyright"] as? String ?? ""

            // If you add more custom subviews to display additional information
            // about your app, configure them here
        }
    }
}
