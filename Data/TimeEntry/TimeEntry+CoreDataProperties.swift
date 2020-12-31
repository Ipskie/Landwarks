//
//  TimeEntry+CoreDataProperties.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftUI

extension TimeEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeEntry> {
        return NSFetchRequest<TimeEntry>(entityName: "TimeEntry")
    }

    @NSManaged public var name: String?
    /// derived property from relationship
    @NSManaged public var projectName: String?
    @NSManaged public var id: Int64
    @NSManaged public var start: Date
    @NSManaged public var end: Date
    @NSManaged public var dur: Double
    @NSManaged public var lastUpdated: Date
    @NSManaged public var lastIndexed: Date
    @NSManaged public var project: Project?
    @NSManaged public var tags: NSSet?
    @NSManaged public var billable: Bool
    @NSManaged public var representative: TimeEntryRepresentative?
    
    /// the `TimeEntry` whose `start` is next.
    @NSManaged public var next: TimeEntry?
    /// the `TimeEntry` whose `start` is previous.
    @NSManaged public var previous: TimeEntry?
    
    public var wrappedDescription: String {
        name ?? "[No Description]"
    }
    
    public var wrappedID: Int {
        Int(id)
    }
    
    public var wrappedColor: Color {
        wrappedProject.color
    }
    
    var wrappedProject: ProjectLike {
        if let project = project {
            return ProjectLike.project(project)
        } else {
            return ProjectLike.special(.NoProject)
        }
    }
    
    public var tagArray: [Tag] {
        return Array(tags as? Set<Tag> ?? [])
    }
    
    public var sortedTags: [Tag] {
        return (tags as? Set<Tag>)?
            .sorted(by: {$0.name < $1.name})
            ?? []
    }
}

extension TimeEntry: TimeEntryLike {
    /// compliance to `TimeEntryLike` protocol
    public var color: Color { wrappedColor }
    public var tagStrings: [String] { tagArray.map{$0.name} } /// just the names of the tags please
    public var entryDescription: String { wrappedDescription }
    public var duration: TimeInterval { dur }
    public var identifier: Int { Int(id) }
}
