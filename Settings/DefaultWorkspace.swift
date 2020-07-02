//
//  DefaultWorkspace.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation


/**
 since workspace IDs can be derived from credentials,
 and do not by themselves grant access to sensitive data,
 and since they are lightweight integers
 we do not store them in the keychain, instead in the User Defaults area
 */
struct WorkspaceManager {
    static let spacesKey = "Clok.WorkspaceIDs"
    static let spaceChosenKey = "Clok.ChosenID"
    
    static let defaults = UserDefaults.standard
    
    static func saveSpaces(_ spaces: [Workspace]) -> Void {
        try! WorkspaceManager.defaults.setValue(
            NSKeyedArchiver.archivedData(
                withRootObject: spaces,
                requiringSecureCoding: false
            ),
            forKey: WorkspaceManager.spacesKey
        )
    }

    static func saveChosen(id: Int) -> Void {
        WorkspaceManager.defaults.setValue(id, forKey: WorkspaceManager.spaceChosenKey)
    }
    
    static func getSpaces() -> [Workspace]? {
        let decoded  = WorkspaceManager.defaults.object(forKey: WorkspaceManager.spacesKey) as! Data
        return try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Workspace.self], from: decoded) as? [Workspace]
        
//        NSCoder().decodeData()
//        guard let data = WorkspaceManager.defaults.data(forKey: WorkspaceManager.spacesKey) else { return nil }
////        try! NSKeyedUnarchiver.unarchivedObject(ofClass: Workspace.self, from: data)
//        NSCoder().deco
//        return try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Workspace.self], from: data) as! [Workspace]
//        return WorkspaceManager.defaults.object(forKey: WorkspaceManager.spacesKey) as? [Workspace]
    }

    // the value UserDefaults returns if nothing was found
    static let defaultInt = 0
    static func getChosen() -> Int? {
        let id = WorkspaceManager.defaults.integer(forKey: WorkspaceManager.spaceChosenKey)
        guard id != 0 else {
            return nil
        }
        return id
    }
}
