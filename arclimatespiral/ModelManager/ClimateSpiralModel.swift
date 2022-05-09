//
//  ClimateSpiralModel.swift
//  arclimatespiral
//
//  Created by Yasuhito Nagatomo on 2022/05/09.
//

import UIKit
import RealityKit

final class ClimateSpiralModel {
    private var baseEntity: Entity?
    private var gridModelEntities: [ModelEntity] = []
    private var ringModelEntities: [ModelEntity] = []
    private var labelModelEntities: [ModelEntity] = []
    private var simpleMaterials: [SimpleMaterial] = []
    
    private var animatingStep = 0

    func baseModelEntity() -> Entity? {
        return baseEntity
    }
    
    func resetAnimation() {
        assert(!ringModelEntities.isEmpty)
        assert(!labelModelEntities.isEmpty)
        
        animatingStep = 0
        ringModelEntities.forEach { entity in
            entity.isEnabled = false
        }
        labelModelEntities.forEach { entity in
            entity.isEnabled = false
        }
    }
    
    func playAnimation() {
        assert(!ringModelEntities.isEmpty)
        assert(!labelModelEntities.isEmpty)
        
        guard animatingStep < ringModelEntities.count else { return }
        guard animatingStep < labelModelEntities.count else { return }
        
        ringModelEntities[animatingStep].isEnabled = true
        labelModelEntities[animatingStep].isEnabled = true
        if animatingStep != 0 {
            labelModelEntities[animatingStep - 1].isEnabled = false
        }
        animatingStep += 1
    }

    func animationFinished() -> Bool {
        return animatingStep >= ringModelEntities.count
    }
}

extension ClimateSpiralModel {
    func setup() {
        assert(gridModelEntities.isEmpty)
        assert(ringModelEntities.isEmpty)
        assert(labelModelEntities.isEmpty)
        
        generateGridModel()
        generateLabelModels()
        generateRingModels()
        
        constructSpiralModel()
    }

    private func constructSpiralModel() {
        baseEntity = Entity()
        
        gridModelEntities.forEach { entity in
            baseEntity?.addChild(entity)
        }
        
        ringModelEntities.forEach { entity in
            baseEntity?.addChild(entity)
        }
        
        labelModelEntities.forEach { entity in
            baseEntity?.addChild(entity)
        }
    }
    
    private func generateGridModel() {
        let model1 = generateCircleModel(radius: ModelConstant.grid1Radius,
                            width: ModelConstant.grid1Width,
                            color: ModelConstant.grid1Color)
        model1.transform.translation = SIMD3<Float>(0.0, ModelConstant.gridOffset, 0.0)
        gridModelEntities.append(model1)
        let model2 = generateCircleModel(radius: ModelConstant.grid2Radius,
                            width: ModelConstant.grid2Width,
                            color: ModelConstant.grid2Color)
        model2.transform.translation = SIMD3<Float>(0.0, ModelConstant.gridOffset, 0.0)
        gridModelEntities.append(model2)
        let model3 = generateCircleModel(radius: ModelConstant.grid3Radius,
                            width: ModelConstant.grid3Width,
                            color: ModelConstant.grid3Color)
        model3.transform.translation = SIMD3<Float>(0.0, ModelConstant.gridOffset, 0.0)
        gridModelEntities.append(model3)
    }
    
    private func generateLabelModels() {
        for index in 0 ..< ClimateData.data.count { // ModelConstant.labelCount {
            let meshResource
            = MeshResource.generateText(String(ClimateData.firstYear + index)
                , extrusionDepth: ModelConstant.labelDepth // [m] z axis
                , font: .systemFont(ofSize: ModelConstant.labelFontSize)
                , containerFrame: .zero // zero : large enough for the text,
                // , alignment: .left
                // lineBreakMode: CTLineBreakMode.byTruncatingTail
                )
            let aveTemperature = ClimateData.average(index: index)
            let material = material(temperature: aveTemperature)
            let model = ModelEntity(mesh: meshResource, materials: [material])
            let yOffset = ModelConstant.ringBaseOffset
                            + Float(index) * ModelConstant.ringGap
            model.transform.translation = SIMD3<Float>(0, yOffset, 0)
            labelModelEntities.append(model)
        }
    }

    private func generateRingModels() {
        var lastPositions: [SIMD3<Float>] = []
        for year in 0 ..< ClimateData.data.count {
            var positions: [SIMD3<Float>] = lastPositions
            var indexes: [UInt32] = []
            let edgeCount = lastPositions.isEmpty ? 11 : 12
            
            for month in 0 ..< 12 {
                let temperature = ClimateData.data[year][month]
                let length = ModelConstant.ringRadius
                                + ModelConstant.ringRadiusOffset * temperature
                let length1 = length + ModelConstant.ringWidth / 2.0
                let length2 = length - ModelConstant.ringWidth / 2.0
                let theta = Float.pi / 2 - Float.pi / 6 * Float(month)
                let yOffset = ModelConstant.ringBaseOffset
                                + Float(year) * ModelConstant.ringGap
                                + Float(month) * ModelConstant.ringGap / 12.0

                let x1 = length1 * cosf(theta)
                let z1 = -length1 * sinf(theta)
                let y1 = yOffset + ModelConstant.ringWidth / 2.0
                let y3 = yOffset - ModelConstant.ringWidth / 2.0

                let x2 = length2 * cosf(theta)
                let z2 = -length2 * sinf(theta)
                let y2 = yOffset + ModelConstant.ringWidth / 2.0
                let y4 = yOffset - ModelConstant.ringWidth / 2.0
                
                positions.append(SIMD3<Float>(x1, y1, z1)) // #0
                positions.append(SIMD3<Float>(x2, y2, z2)) // #1
                positions.append(SIMD3<Float>(x1, y3, z1)) // #2
                positions.append(SIMD3<Float>(x2, y4, z2)) // #3
                
                if month == 11 {
                    lastPositions = []
                    lastPositions.append(SIMD3<Float>(x1, y1, z1)) // #0
                    lastPositions.append(SIMD3<Float>(x2, y2, z2)) // #1
                    lastPositions.append(SIMD3<Float>(x1, y3, z1)) // #2
                    lastPositions.append(SIMD3<Float>(x2, y4, z2)) // #3
                }
            }

            for edge in 0 ..< edgeCount {
                let stride = UInt32(edge * 4)
                indexes.append(contentsOf: [4 + stride, 0 + stride, 5 + stride,
                                            5 + stride, 0 + stride, 1 + stride,
                                            5 + stride, 1 + stride, 7 + stride,
                                            7 + stride, 1 + stride, 3 + stride,
                                            7 + stride, 3 + stride, 6 + stride,
                                            6 + stride, 3 + stride, 2 + stride,
                                            6 + stride, 2 + stride, 4 + stride,
                                            4 + stride, 2 + stride, 0 + stride])
            }
            
            var descriptor = MeshDescriptor()
            descriptor.positions = MeshBuffers.Positions(positions)
            descriptor.primitives = .triangles(indexes)
            descriptor.materials = .allFaces(0) // .perFace([0])
            
            let aveTemperature = ClimateData.average(index: year)
            if let meshResource = try? MeshResource.generate(from: [descriptor]) {
                let model = ModelEntity(mesh: meshResource,
                            materials: [material(temperature: aveTemperature)])
                ringModelEntities.append(model)
            } else {
                fatalError("failed to generate meshResource.")
            }
        }
    }
    
    //    SIMD3<Float>(0.0, 0.0, 1.0), // blue   -1.0 [Celsius]
    //    SIMD3<Float>(0.0, 1.0, 1.0), // cyan   -0.5
    //    SIMD3<Float>(1.0, 1.0, 1.0), // white   0.0
    //    SIMD3<Float>(1.0, 0.5, 0.0), // orange  0.5
    //    SIMD3<Float>(1.0, 0.0, 0.0)]  // red    1.0
    private func material(temperature: Float) -> SimpleMaterial {
        var red: CGFloat, green: CGFloat, blue: CGFloat
        if temperature <= -1.0 { // blue
            red = 0.0
            green = 0.0
            blue = 1.0
        }
        else if temperature <= -0.5 { // blue -> cyan
            let temp = (temperature + 1.0) * 2.0
            red = 0.0
            green = CGFloat(temp)
            blue = 1.0
        }
        else if temperature <= 0 { // cyan -> white
            let temp = (temperature + 0.5) * 2.0
            red = CGFloat(temp)
            green = 1.0
            blue = 1.0
        }
        else if temperature <= 0.5 { // white -> orange
            red = 1.0
            green = 1.0 - CGFloat(temperature)
            blue = 1.0 - CGFloat(temperature * 2.0)
        }
        else if temperature <= 1.0 { // orange -> red
            let temp = temperature - 0.5
            red = 1.0
            green = 0.5 - CGFloat(temp)
            blue = 0.0
        }
        else { // red
            red = 1.0
            green = 0.0
            blue = 0.0
        }
        
        return SimpleMaterial(color: UIColor(red: red, green: green, blue: blue, alpha: 1.0),
                              isMetallic: false)
    }
    
    private func generateCircleModel(radius: Float, width: Float, color: UIColor)
    -> ModelEntity {
        var positions: [SIMD3<Float>] = []
        var indexes: [UInt32] = []
        let edgeCount = 12
        
        for month in 0 ... 12 {
            let length = radius
            let length1 = length + width / 2.0
            let length2 = length - width / 2.0
            let theta = Float.pi / 2 - Float.pi / 6 * Float(month)
            let yOffset: Float = 0.0
            
            let x1 = length1 * cosf(theta)
            let z1 = -length1 * sinf(theta)
            let y1 = yOffset + width / 2.0
            let y3 = yOffset - width / 2.0

            let x2 = length2 * cosf(theta)
            let z2 = -length2 * sinf(theta)
            let y2 = yOffset + width / 2.0
            let y4 = yOffset - width / 2.0
            
            positions.append(SIMD3<Float>(x1, y1, z1)) // #0
            positions.append(SIMD3<Float>(x2, y2, z2)) // #1
            positions.append(SIMD3<Float>(x1, y3, z1)) // #2
            positions.append(SIMD3<Float>(x2, y4, z2)) // #3
        }

        for edge in 0 ..< edgeCount {
            let stride = UInt32(edge * 4)
            indexes.append(contentsOf: [4 + stride, 0 + stride, 5 + stride,
                                        5 + stride, 0 + stride, 1 + stride,
                                        5 + stride, 1 + stride, 7 + stride,
                                        7 + stride, 1 + stride, 3 + stride,
                                        7 + stride, 3 + stride, 6 + stride,
                                        6 + stride, 3 + stride, 2 + stride,
                                        6 + stride, 2 + stride, 4 + stride,
                                        4 + stride, 2 + stride, 0 + stride])
        }
        
        var descriptor = MeshDescriptor()
        descriptor.positions = MeshBuffers.Positions(positions)
        descriptor.primitives = .triangles(indexes)
        descriptor.materials = .allFaces(0) // .perFace([0])
        
        var model: ModelEntity
        if let meshResource = try? MeshResource.generate(from: [descriptor]) {
            let material = SimpleMaterial(color: color, isMetallic: false)
            model = ModelEntity(mesh: meshResource, materials: [material])
        } else {
            fatalError("failed to generate meshResource.")
        }
        
        return model
    }
}
