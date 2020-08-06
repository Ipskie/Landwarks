//
//  DayStrip.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

fileprivate let labelOffset = CGFloat(-10)
fileprivate let labelPadding = CGFloat(3)

/// One vertical strip of bars representing 1 day in the larger graph
struct DayStrip: View {
    
    @EnvironmentObject var bounds: Bounds
    let entries: [TimeEntry]
    let begin: Date
    let terms: SearchTerm
    let df = DateFormatter()
    let days: Int
    let noPad: Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                HeaderLabel
                    .offset(y: bounds.insets.top - geo.frame(in: .global).minY)
                    .zIndex(1) /// ensure this is drawn first, but remains on top
                VStack(spacing: .zero) {
                    ForEach(0..<entries.count, id: \.self) { idx in
                        LineBar(
                            entry: entries[idx],
                            begin: begin,
                            size: geo.size,
                            days: days
                        )
                            .padding(.top, padding(for: idx, size: geo.size))
                            .opacity(entries[idx].matches(terms) ? 1 : 0.5)
                    }
                }
                
            }
        }
    }
    
    /// calculate appropriate distance to next time entry
    func padding(for idx: Int, size: CGSize) -> CGFloat {
        let scale = size.height / CGFloat(dayLength * Double(days))
        /// for first entry, always check against `begin`
        guard idx != 0 else {
            return scale * CGFloat(entries[0].start - begin)
        }
        
        if !noPad {
            return CGFloat(entries[idx].start - entries[idx - 1].end) * scale
        } else {
            return .zero
        }
        
        
    }
    
    var HeaderLabel: some View {
        /// short weekday and date labels
        VStack(spacing: .zero) {
            Text((begin + dayLength).shortWeekday())
                .font(.footnote)
                .lineLimit(1)
            DateLabel(for: begin)
                .font(.caption)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .background(Color.clokBG)

    }
    
    func DateLabel(for date: Date) -> Text {
        /// add 1 day to compensate for the day strip covering 3 days
        let date = date + dayLength
        if Calendar.current.component(.day, from: date) == 1 {
            df.setLocalizedDateFormatFromTemplate("MMM")
            return Text(df.string(from: date)).bold()
        } else {
            df.setLocalizedDateFormatFromTemplate("dd")
            return Text(df.string(from: date))
        }
    }
}
