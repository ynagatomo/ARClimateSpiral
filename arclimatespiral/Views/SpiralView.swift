//
//  SpiralView.swift
//  arclimatespiral
//
//  Created by Yasuhito Nagatomo on 2022/05/08.
//

import SwiftUI

struct SpiralView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            ARContainerView()
                .background(.black) // shown during starting up ARView
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: dismiss.callAsFunction) {
                        Image(systemName: "xmark.circle")
                            .font(.largeTitle)
                            .padding(4)
                    }
                    .tint(.orange)
                }
                Spacer()
            } // VStack
            .padding(32)
        } // ZStack
        .ignoresSafeArea()
    }
}

struct SpiralView_Previews: PreviewProvider {
    static var previews: some View {
        SpiralView()
    }
}

