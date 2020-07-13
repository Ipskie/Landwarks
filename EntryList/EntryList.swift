//
//  EntryList.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

let listPadding = CGFloat(7)

struct EntryList: View {
    
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var zero: ZeroDate
    @EnvironmentObject var listRow: ListRow
    @FetchRequest(entity: TimeEntry.entity(), sortDescriptors: []) var entries: FetchedResults<TimeEntry>
    
    private let df = DateFormatter()
    
    init() {
        df.setLocalizedDateFormatFromTemplate("MMMdd")
    }
    
    var body: some View {
        ScrollView {
            ScrollViewReader { value in
                Title(value)
                ForEach(Days(), id: \.id) { day in
                    Section(header: Header(day)) {
                        LazyVStack(spacing: 0) {
                            ForEach(day.entries, id: \.id) { entry in
                                EntryView(entry: entry)
                                    .id(entry.id)
                            }
                        }
                    }
                }
            }
            /// easter egg!
            if zero.date > Date() + weekLength {
                Text("What does the future hold?")
            }
        }
        .allowsHitTesting(false)
    }
    
    func Title(_ value: ScrollViewProxy) -> some View {
        HStack {
            Text("Time Entries")
                .font(Font.title.weight(.bold))
                .onReceive(listRow.$entry, perform: { entry in
                    withAnimation {
                        value.scrollTo(entry?.id, anchor: .top)
                    }
                })
            Spacer()
        }
        .padding(listPadding)
    }
    
    func Header(_ day: Day) -> some View {
        let cal = Calendar.current
        let currentYear = cal.component(.year, from: Date())
        let zeroYear = cal.component(.year, from: zero.date)
                
        /// day of week, day of month, MMM
        let dateString =  [
            day.start.shortWeekday(),
            df.string(from: day.start),
            /// plus optional YYYY if it is not current year
            ((currentYear == zeroYear) ? "" : "\(zeroYear)")
        ].joined(separator: " ")
        
        return VStack {
            HStack {
                Text(dateString)
                    .font(Font.title2.weight(.bold))
                Spacer()
            }
            Divider()
        }
        .padding([.leading, .trailing], listPadding)
    }
    
    struct Day {
        var id: Int
        var start: Date
        var entries: [TimeEntry]
    }
    
    func Days() -> [Day] {
        /// restrict to current week
        let validEntries = entries
            .sorted(by: {$0.wrappedStart < $1.wrappedStart} )
            .within(interval: weekLength, of: zero.date)
            .matching(data.terms)
        
        var days = [Day]()
        let cal = Calendar.current
        for mn in stride(
            from: cal.startOfDay(for: zero.date),
            through: cal.startOfDay(for: zero.date + weekLength),
            by: dayLength
        ) {
            days.append(Day(
                id: Int(mn.timeIntervalSince1970),
                start: mn,
                entries: validEntries
                    /// restrict entries to those that started in this 24 hour period
                    /// NOTE: don't user `within`, as this causes some entries to appear across 2 days, causing a crash!
                    .filter{ $0.wrappedStart.between(mn, mn + dayLength) }
            ))
        }
        
        return days.filter{ $0.entries.count > 0 }
    }
    
    func HeaderFor(section: Day) -> String {
        let cal = Calendar.current
        let currentYear = cal.component(.year, from: Date())
        let zeroYear = cal.component(.year, from: zero.date)
        
        /// day of week, day of month, MMM
        return [
            section.start.shortWeekday(),
            df.string(from: section.start),
            /// plus optional YYYY if it is not current year
            ((currentYear == zeroYear) ? "" : "\(zeroYear)")
        ].joined(separator: " ")
    }
}

struct EntryList_Previews: PreviewProvider {
    static var previews: some View {
        EntryList()
    }
}
