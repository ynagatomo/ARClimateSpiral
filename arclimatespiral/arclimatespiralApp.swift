//
//  arclimatespiralApp.swift
//  arclimatespiral
//
//  Created by Yasuhito Nagatomo on 2022/05/07.
//

import SwiftUI

@main
struct arclimatespiralApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear {
                    ModelManager.shared.setup()
                }
        }
    }
}
