//
//  ARSceneConstant.swift
//  arclimatespiral
//
//  Created by Yasuhito Nagatomo on 2022/05/08.
//

import Foundation

final class ARSceneConstant {
    private init() {}

    // AR World
    static let worldOriginForDevice: SIMD3<Float> = [0.0, 0.0, -0.3]
    static let worldOriginForMac: SIMD3<Float> = [0.0, 0.0, -0.3]
    
    // Model
    static let modelScale: SIMD3<Float> = [0.5, 0.5, 0.5]
    
    // Animation
    static let animationInterval: Double = 1.0/30.0 // 10.0 // [sec] interval time between frames
}
