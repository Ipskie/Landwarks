//
//  LineGraph.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct LineGraph: View {
    
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var zero: ZeroDate
    /// for now, show 7 days
    static let dayCount = 7
    
    @GestureState var magnifyBy = CGFloat(1.0)
    @State var dragBy = PositionTracker()
    
    let tf = DateFormatter()
    let haptic = UIImpactFeedbackGenerator(style: .light)
    init(){
        tf.timeStyle = .short
    }
    
    /// slows down the magnifying effect by some constant
    let kCoeff = 0.5
    
    var body: some View {
        /// check whether the provided time entry coincides with a particular *date* range
        /// if our entry ends before the interval even began
        /// or started after the interval finished, it cannot possibly fall coincide
        VStack {
            Text("TESTING")
            GeometryReader { geo in
                ZStack {
                    Rectangle().foregroundColor(.clokBG)
                     ForEach(data.entries.filter {$0.wrappedEnd > zero.date && $0.wrappedStart < zero.date + weekLength}, id: \.id) { entry in
                        LineBar(with: entry, geo: geo, bounds: GetBounds(zero: zero, entry: entry))
                            .transition(.identity)
                            .animation(.linear)
                    }
                }
                .drawingGroup()
                .gesture(Drag(geo: geo))
            }
            .border(Color.red)
        }
    }
    
    func Drag(geo: GeometryProxy) -> some Gesture {
        func useValue(value: DragGesture.Value, geo: GeometryProxy) -> Void {
            /// find cursor's
            dragBy.update(state: value, geo: geo)
        
            withAnimation {
                zero.date -= dragBy.intervalDiff * zero.interval
            }
            
            let days = dragBy.harvestDays()
            if days != 0 {
                haptic.impactOccurred(intensity: 1)
                withAnimation {
                    zero.date -= Double(days) * dayLength
                }
            }
        }
        return DragGesture()
            .onChanged {
                useValue(value: $0, geo: geo)
            }
            .onEnded {
                /// update once more on end
                useValue(value: $0, geo: geo)
                dragBy.reset()
            }
    }
}
