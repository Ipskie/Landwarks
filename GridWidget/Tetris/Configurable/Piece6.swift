//
//  Piece6.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension ConfigurablePiece {
    static let _6 = ConfigurablePiece(
        value: 6,
        pieces: [
            TetrisPiece([
                [true, true],
                [true, true],
                [true, true]
            ]),
            TetrisPiece([
                [true, true, true],
                [true, true, true]
            ]),
            /// more
        ]
    )
}
