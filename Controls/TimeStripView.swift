//
//  TimeStripView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.21.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct TimeStripView: View {
    @EnvironmentObject private var zero: ZeroDate
    
    
    private let padding = CGFloat(7)
    private let tf = DateFormatter()
    
    init () {
        tf.timeStyle = .short
    }
    
    var body: some View {
        HStack {
            if UIDevice.hasNotch {
                WeekDateButton()
                    .modifier(TabStyle())
                
                Spacer()
                Text(self.tf.string(from: self.zero.date))
                    .modifier(TabStyle())
            } else {
                WeekDateButton()
                    .modifier(StickStyle(round: .right))
                
                Spacer()
                Text(self.tf.string(from: self.zero.date))
                    .modifier(StickStyle(round: .left))
            }
            
        }
        /// send to the bottom
    }
    
    
}

struct StickStyle: ViewModifier {
    var round: IceCreamStick.rounded
    private let padding = CGFloat(10)
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
               RaisedShape(radius: padding / 2){ IceCreamStick(round: round) }
            )
            .padding([.top], padding / 2)
    }
}

struct TabStyle: ViewModifier {
    private let padding = CGFloat(10)
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
               RaisedShape(radius: padding / 2){ RoundBottomRect() }
            )
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
