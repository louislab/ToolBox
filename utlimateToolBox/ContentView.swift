//
//  ContentView.swift
//  utlimateToolBox
//
//  Created by Louis Lee on 12/12/2021.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: OpenAIView(),
                    label: {
                    Image("OpenAI")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
            }
            .navigationTitle("ToolBox")
            .navigationBarTitleDisplayMode(.large)
        }
        .preferredColorScheme(.light) // now only support light mode
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
