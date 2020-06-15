//
//  ActivityIndicator.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.31.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct ProgressIndicator: View {
    var body: some View {
        ActivityIndicator()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.all)
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let uiView = UIActivityIndicatorView()
        uiView.startAnimating()
        return uiView
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        // Start and stop UIActivityIndicatorView animation
    }
}
