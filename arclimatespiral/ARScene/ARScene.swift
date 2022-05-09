//
//  ARScene.swift
//  arclimatespiral
//
//  Created by Yasuhito Nagatomo on 2022/05/08.
//

import Foundation
import RealityKit
import Combine

final class ARScene {
    enum State { case stop, playing }
    private var state: State = .stop
    private var accumulativeTime: Double = 0.0
    private var renderLoopSubscription: Cancellable?

    func setup(anchor: AnchorEntity) {
        ModelManager.shared.resetAnimation()
        if let baseModelEntity = ModelManager.shared.getBaseModel() {
            baseModelEntity.scale = ARSceneConstant.modelScale
            anchor.addChild(baseModelEntity)
        }
    }
    
    func startSession(arView: ARView) {
        startAnimation(arView: arView)
    }
    
    func stopSession() {
        stopAnimation()
    }
    
    private func startAnimation(arView: ARView) {
        state = .playing
        renderLoopSubscription = arView.scene.subscribe(to: SceneEvents.Update.self)
        { event in
            DispatchQueue.main.async {
                self.update(deltaTime: event.deltaTime)
            }
        }
    }
    
    private func stopAnimation() {
        guard state == .playing else { return }
        state = .stop
        renderLoopSubscription?.cancel()
        renderLoopSubscription = nil
    }
    
    private func update(deltaTime: Double) {
        accumulativeTime += deltaTime
        if accumulativeTime > ARSceneConstant.animationInterval {
            accumulativeTime = 0.0
            ModelManager.shared.playAnimation()
            if ModelManager.shared.animationFinished() {
                stopAnimation()
            }
        }
    }
}
