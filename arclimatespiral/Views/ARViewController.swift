//
//  ARViewController.swift
//  arclimatespiral
//
//  Created by Yasuhito Nagatomo on 2022/05/08.
//

import UIKit
import ARKit
import RealityKit

final class ARViewController: UIViewController {
    private var arView: ARView!
    private var arScene: ARScene!
    
    override func viewDidLoad() {
        #if targetEnvironment(simulator)
        arView = ARView(frame: .zero)
        #else
        if ProcessInfo.processInfo.isiOSAppOnMac {
            arView = ARView(frame: .zero, cameraMode: .nonAR,
                            automaticallyConfigureSession: true)
        } else {
            arView = ARView(frame: .zero, cameraMode: .ar,
                            automaticallyConfigureSession: false)
        }
        #endif
        // arView.session.delegate = self

        #if DEBUG
        arView.debugOptions = [.showAnchorOrigins,
                               .showAnchorGeometry]
        #endif
        
        view = arView
        
        var anchorEntity: AnchorEntity!
        #if targetEnvironment(simulator)
        anchorEntity = AnchorEntity(world: ARSceneConstant.worldOriginForMac)
        #else
        if ProcessInfo.processInfo.isiOSAppOnMac {
            anchorEntity = AnchorEntity(world: ARSceneConstant.worldOriginForMac)
        } else {
            anchorEntity = AnchorEntity(world: ARSceneConstant.worldOriginForDevice)
        }
        #endif
        arView.scene.addAnchor(anchorEntity)
        
        arScene = ARScene()
        arScene.setup(anchor: anchorEntity)
        
        #if !targetEnvironment(simulator)
        if !ProcessInfo.processInfo.isiOSAppOnMac {
            let config = ARWorldTrackingConfiguration()
            arView.session.run(config)
        }
        #endif

        arScene.startSession(arView: arView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        arScene.stopSession()
    }
}
