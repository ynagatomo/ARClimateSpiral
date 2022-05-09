//
//  HomeView.swift
//  arclimatespiral
//
//  Created by Yasuhito Nagatomo on 2022/05/08.
//

import SwiftUI

struct HomeView: View {
    @State private var showingARView = false
    
    var body: some View {
        ZStack {
            Color("HomeBGColor") // Background
            VStack {
                description
                
                Button(action: {
                    showingARView = true
                }, label: {
                    Text("Visualize in AR")
                })
            } // VStack
        } // ZStack
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .fullScreenCover(isPresented: $showingARView) {
            SpiralView()
        }
    }

    private var description: some View {
        VStack {
            Text("Global Climate Change")
                .foregroundColor(.gray)
                .padding()
            
            Text("Climate Spiral")
                .foregroundColor(.white)
                .font(.largeTitle)
                .padding()
            
            Text("It shows monthly global temperature anomalies (changes from an average) between the years 1880 and 2021. Whites and blues indicate cooler temperatures, while oranges and reds show warmer temperatures.")
                .foregroundColor(.white)
                .padding()
            
            Text("Credit: NASA's Scientific Visualization Studio")
                .font(.caption)
                .foregroundColor(.gray)
        } // VStack
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
        }
    }
}
