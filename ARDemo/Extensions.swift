//
//  Extensions.swift
//  ARDemo
//
//  Created by Владислав Форафонтов on 28.05.2018.
//  Copyright © 2018 Владислав Форафонтов. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        
        let plane = Plane(anchor: anchor as! ARPlaneAnchor)
        self.planes.append(plane)
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let plane = self.planes.filter { plane in
            return plane.anchor.identifier == anchor.identifier
            }.first
        
        guard plane != nil else {return}
        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }
}

// MARK: - SettingsViewDelegate
extension ViewController: SettingsViewDelegate {
    func weatherWasChanged(on state: WeatherState) {
        switch state {
        case .fog: create(particle: Weathers.fog)
        case .rain: create(particle: Weathers.rain)
        case .snow: create(particle: Weathers.snow)
        default: create(particle: nil)
        }
    }
    
    func dayWasChanged(on state: DayState) {
        // TODO: - day and night will change THIS
    }
}
