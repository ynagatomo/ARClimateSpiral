//
//  ModelConstant.swift
//  arclimatespiral
//
//  Created by Yasuhito Nagatomo on 2022/05/09.
//

import Foundation
import CoreGraphics
import UIKit

final class ModelConstant {
    private init() {}

    static let ringBaseOffset: Float = -1.4 / 2.0 // [m] y-axis
    static let ringGap: Float = 0.01 // [m] y-axis
    static let ringWidth: Float = 0.01 // [m]
    static let ringRadius: Float = 0.5 // [m]
    static let ringRadiusOffset: Float = 0.25 // [m]
    
    // Year Label Models
    static let labelDepth: Float = 0.02 // [m] z-axis
    static let labelFontSize: CGFloat = 0.1
    
    // Grid Models
    static let gridOffset: Float = -1.4 / 2.0 // [m] y-axis
    static let grid1Radius: Float = 0.25 // [m]
    static let grid1Width: Float = 0.01 // [m]
    static let grid1Color: UIColor = UIColor(red: 0.7,
                                             green: 0.6,
                                             blue: 0.3,
                                             alpha: 1.0)
    static let grid2Radius: Float = 0.5 // [m]
    static let grid2Width: Float = 0.01 // [m]
    static let grid2Color: UIColor = UIColor(red: 0.0,
                                             green: 0.5,
                                             blue: 0.3,
                                             alpha: 1.0)
    static let grid3Radius: Float = 0.75 // [m]
    static let grid3Width: Float = 0.01 // [m]
    static let grid3Color: UIColor = UIColor(red: 0.7,
                                             green: 0.6,
                                             blue: 0.3,
                                             alpha: 1.0)
}
