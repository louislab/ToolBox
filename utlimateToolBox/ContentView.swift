//
//  ContentView.swift
//  utlimateToolBox
//
//  Created by Louis Lee on 12/12/2021.
//

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
