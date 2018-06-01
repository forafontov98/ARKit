//
//  Box.swift
//  ARDemo
//
//  Created by Владислав Форафонтов on 16.05.2018.
//  Copyright © 2018 Владислав Форафонтов. All rights reserved.
//

import SceneKit
import ARKit

class Box: SCNNode {
    init(atPosition position: SCNVector3) {
        super.init()
        
        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        
        boxGeometry.materials = [material]
        
        self.geometry = boxGeometry
        
        let physicsShape = SCNPhysicsShape(geometry: self.geometry!, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicsShape)
        self.physicsBody?.categoryBitMask = BitMaskCategory.box
        self.physicsBody?.collisionBitMask = BitMaskCategory.box | BitMaskCategory.plane
        self.physicsBody?.contactTestBitMask = BitMaskCategory.plane
        
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
