//
//  StatView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.14.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct StatView: View {
    var week: WeekTimeFrame
    private let df = DateFormatter()
    private var avgStart = Date()
    private var avgEnd = Date()
    private var avgDur: TimeInterval = 0
    
    var body: some View {
        VStack {
            Text("Starts Around: " + df.string(from: avgStart))
            Text("Ends Around: " + df.string(from: avgEnd))
            Text("Time / day: " + avgDur.toString())
        }
        
    }
    
    init(over week_: WeekTimeFrame, for terms: SearchTerm) {
        week = week_
        avgStart = week.avgStartTime(for: terms)
        avgEnd   = week.avgEndTime(for: terms)
        
        df.timeStyle = .short
        df.dateStyle = .none
    }
}
