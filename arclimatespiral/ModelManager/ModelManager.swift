//
//  ModelManager.swift
//  arclimatespiral
//
//  Created by Yasuhito Nagatomo on 2022/05/08.
//

import RealityKit

final class ModelManager {
    static let shared = ModelManager()

    private let climateSpiralModel = ClimateSpiralModel()
    private init() { }

    func setup() {
        climateSpiralModel.setup()
    }
    
    func getBaseModel() -> Entity? {
        return climateSpiralModel.baseModelEntity()
    }
    
    func resetAnimation() {
        climateSpiralModel.resetAnimation()
    }
    
    func playAnimation() {
        climateSpiralModel.playAnimation()
    }
    
    func animationFinished() -> Bool {
        return climateSpiralModel.animationFinished()
    }
}

