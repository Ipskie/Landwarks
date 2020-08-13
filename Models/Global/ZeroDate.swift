//
//  ZeroDate.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.17.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class ZeroDate: ObservableObject {
    init(start: Date){
        self.start = start
    }
    
    /// default to 6 days before start of today
    /// ensures the default week includes today
    @Published var start: Date
    
    /// computed end date
    var end: Date {
        start + .week
    }
    
    /// whether the date was moved forwards of backwards
    enum DateChange {
        case fwrd
        case back
    }
    
    @Published var dateChange : DateChange? = nil
    
    /// whether the time indicating clock hands should be on screen
    @Published var showTime = false
    
    // MARK:- Zoom Level
    /// length of time interval being examined
    /// defaults to 8 hours
    let objectWillChange = ObservableObjectPublisher()
    var zoomIdx = WorkspaceManager.zoomIdx {
        willSet {
            /// cap `zoomIndex` to valid indices
            let safeVal = min(max(newValue, 0), zoomLevels.count - 1)
            WorkspaceManager.zoomIdx = safeVal
            objectWillChange.send()
        }
    }
    var zoomLevel: CGFloat {
        /// cap `zoomIndex` to valid indices
        zoomLevels[min(max(zoomIdx, 0), zoomLevels.count - 1)]
    }
    var interval: TimeInterval {
        .day / Double(zoomLevel)
    }
    
    let zoomLevels: [CGFloat] = [
        1.0, /// 24hr
        1.5, /// 16hr
        2.0, /// 12hr
        3.0, /// 8hr
        4.0, /// 6hr
        6.0, /// 4hr
        8.0, /// 3hr
        12.0,/// 2hr
        24.0 /// 1hr
    ]
}

extension ZeroDate {
    /**
     a short string marking the `start` and `end` of this week
     */
    var weekString: String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMdd")
        /// slightly adjust `end` so that it falls before midnight, into the previous day
        return "\(df.string(from: start)) – \(df.string(from: end - 1))"
    }
}
