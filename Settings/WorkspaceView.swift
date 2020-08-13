//
//  WorkspaceView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct WorkspaceMenu: View {
    
    @EnvironmentObject private var settings: Settings
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(settings.user?.workspaces ?? [], id: \.wid) { space in
                Button {
                    settings.user?.chosen = space // set chosen space (updates Spiral)
                    WorkspaceManager.chosenWorkspace = space // write choice to disk for future launches
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(space.name)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .navigationTitle(Text("Workspace"))
    }
}

