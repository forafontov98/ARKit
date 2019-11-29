//
//  VObjectBuilder.swift
//  ARDemo
//
//  Created by Владислав Форафонтов on 28/11/2019.
//  Copyright © 2019 Владислав Форафонтов. All rights reserved.
//

import Foundation
import SceneKit

protocol VObjectBuilderProtocol {
    func setPosition(pos: SCNVector3, scale: Double)
    func setTexture(_ texture: UIImage?)
}

class VObjectBuilder: VObjectBuilderProtocol {
    
    private (set) var vObj: VObjectProtocol?
    
    init(_ obj: VObjectProtocol) {
        vObj = obj
    }
    
    func setPosition(pos: SCNVector3, scale: Double) {
        vObj?.object.position = pos
        vObj?.object.scale = SCNVector3(scale, scale, scale)
        vObj?.object.load()
    }
    
    func setTexture(_ texture: UIImage?) {
        let textureMaterial = SCNMaterial()
        textureMaterial.diffuse.contents = texture
        textureMaterial.specular.contents = texture
        
        vObj?.object?.childNodes.first?.geometry?.materials = [textureMaterial]
        vObj?.object?.geometry?.materials = [textureMaterial]
    }
    

}
