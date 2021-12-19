//
//  ContentView.swift
//  utlimateToolBox
//
//  Created by Louis Lee on 12/12/2021.
//

/**
 * Update guide:
 *
 * For engines:
 *  1. Update the list of engines in CompletionView_menu
 *   - engines [String]
 *
 * For presets:
 *  1. Update the preset list in PresetsView
 *   - enum Presets
 *  2. Append the preset values in PresetsView
 *   - func build()
 *  3. Insert the button into PresetsView, followed by hardcoded random presetStyles (shuffle technique)
 */

import SwiftUI

struct ContentView: View {
    @State var isActive : Bool = false
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CompletionsView(rootIsActive: self.$isActive), isActive: self.$isActive, label: {
                    Image("OpenAI")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
                    .isDetailLink(false)
            }
            .navigationTitle("ToolBox")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(.light) // now only support light mode
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
