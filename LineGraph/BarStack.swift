//
//  BarStack.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 10/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct BarStack: View {
    
    @EnvironmentObject private var bounds: Bounds
    @EnvironmentObject private var zero: ZeroDate
    
    /// make a meaningless update to zero Date so it will load data from disk
    func jumpCoreDate() {
        zero.start += .leastNonzeroMagnitude
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                Mask {
                    DayScroll(size: geo.size)
                }
                
            
                HStack {
                    FilterStack()
                        .padding(buttonPadding)
                    Image(systemName: "chevron.left.2")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .back
                            withAnimation {
                                zero.start -= dayLength * Double(zero.dayCount)
                            }
                        }
                    Image(systemName: "chevron.left")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .back
                            withAnimation {
                                zero.start -= dayLength
                            }
                        }
                    Image(systemName: "chevron.right")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .fwrd
                            withAnimation {
                                zero.start += dayLength
                            }
                        }
                    Image(systemName: "chevron.right.2")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .fwrd
                            withAnimation {
                                zero.start += dayLength * Double(zero.dayCount)
                            }
                        }
                    Image(systemName: "plus")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .none
                            withAnimation {
                                zero.dayCount = min(zero.countMax, zero.dayCount + 1)
                            }
                        }
                    Image(systemName: "minus")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .none
                            withAnimation {
                                zero.dayCount = max(zero.countMin, zero.dayCount - 1)
                            }
                        }
                }
            }
        }
        /// keep it square
        .aspectRatio(1, contentMode: bounds.notch ? .fit : .fill)
        .onAppear(perform: jumpCoreDate)
    }
    
    func DayScroll(size: CGSize) -> some View {
        VStack(spacing: .zero) {
            Text(" ")
                .frame(height: 1)
            ScrollView(.vertical) {
                ScrollViewReader { proxy in
                    
                    /// scroll anchor allows view to appear in the right position
                    EmptyView()
                        .id(0)
                        .offset(y: size.height)
                
                    HStack {
                        TimeIndicator(divisions: evenDivisions(for: size), days: 3)
                            .layoutPriority(1) /// prevent it from shrinking
                            .frame(height: size.height * 3)
                        GeometryReader { newGeo in
                            ScrollView(.horizontal, showsIndicators: false) {
                                LineGraph(size: size)
                                    /// use reduced width
                                    .frame(width: newGeo.size.width, height: size.height * 3)
                            }
                        }
                        
                        .onAppear{ proxy.scrollTo(0, anchor: .center) }
                    }
                    .padding([.top, .bottom], -size.height / 2)
                }
            }
        }
        
    }
}
