//
//  ScriptHelper.swift
//  YogaSMC
//
//  Created by Zhen on 10/14/20.
//  Copyright © 2020 Zhen. All rights reserved.
//

import AppKit
import Foundation
import ScriptingBridge
import os.log

let prefpaneAS = """
                    tell application "System Preferences"
                        reveal pane "org.zhen.YogaSMCPane"
                        activate
                    end tell
                 """
let lockAS = "tell application \"System Events\" to keystroke \"q\" using {control down, command down}"

let sleepAS = "tell application \"System Events\" to sleep"

let searchAS = "tell application \"System Events\" to keystroke space using {command down, option down}"
let spotlightAS = "tell application \"System Events\" to keystroke space using {command down}"
let siriAS = """
                tell application "System Events" to tell the front menu bar of process "SystemUIServer"
                  tell (first menu bar item whose description is "Siri")
                     perform action "AXPress"
                  end tell
                end tell
             """
let reloadAS = """
                  tell application "YogaSMCNC" to quit
                  tell application "YogaSMCNC" to activate
               """
let stopAS = "tell application \"YogaSMCNC\" to quit"
let startAS = "tell application \"YogaSMCNC\" to activate"

let getAudioMutedAS = "output muted of (get volume settings)"
let setAudioMuteAS = "set volume with output muted"
let setAudioUnmuteAS = "set volume without output muted"

let getMicVolumeAS = "input volume of (get volume settings)"
let setMicVolumeAS = "set volume input volume %d"

// based on https://medium.com/macoclock/1ba82537f7c3
func scriptHelper(_ source: String, _ name: String, _ image: NSString? = nil) -> NSAppleEventDescriptor? {
    if let scpt = NSAppleScript(source: source) {
        var error: NSDictionary?
        let ret = scpt.executeAndReturnError(&error)
        if error == nil {
            if let img = image {
                showOSD(name, img)
            }
            return ret
        }
    }
    if #available(macOS 10.12, *) {
        os_log("%s: failed to execute script", type: .error, name)
    }
    return nil
}

func prefpaneHelper() {
    
    let homeDir = NSHomeDirectory()
    let path = "\(homeDir)/Library/PreferencePanes/"
    let path2 = "/Library/PreferencePanes/"
    let url = NSURL(fileURLWithPath: path)
    let url2 = NSURL(fileURLWithPath: path2)
    
    if let pathComponent = url.appendingPathComponent("YogaSMCPane.prefPane"), let pathComponent2 = url2.appendingPathComponent("YogaSMCPane.prefPane") {
            let filePath = pathComponent.path
            let filePath2 = pathComponent2.path
            let fileManager = FileManager.default
        
            if fileManager.fileExists(atPath: filePath ) || fileManager.fileExists(atPath: filePath2 )  {
                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference")!)
                NSWorkspace.shared.open(URL(fileURLWithPath: "\(homeDir)/Library/PreferencePanes/YogaSMCPane.prefPane"))
                NSWorkspace.shared.open(URL(fileURLWithPath: "/Library/PreferencePanes/YogaSMCPane.prefPane"))
                return
            } else {
                let alert = NSAlert()
                            alert.messageText = "Failed to open Preferences/Settings"
                            alert.informativeText = "Please install YogaSMCPane"
                            alert.alertStyle = .warning
                            alert.addButton(withTitle: "OK")
                            alert.runModal()
            }
        }
    
}
