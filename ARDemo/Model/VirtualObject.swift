//
//  VirtualObject.swift
//  ARDemo
//
//  Created by Владислав Форафонтов on 18.05.2018.
//  Copyright © 2018 Владислав Форафонтов. All rights reserved.
//

import SceneKit

class VirtualObject: SCNReferenceNode {
    
    static let availableObjects: [SCNReferenceNode] = {
        guard let modelsURLs = Bundle.main.url(forResource: "art.scnassets", withExtension: nil) else {return []}
        
        let fileEnumerator = FileManager().enumerator(at: modelsURLs, includingPropertiesForKeys: nil)!
        
        return fileEnumerator.flatMap { element in
            let url = element as! URL
            guard url.pathExtension == "scn" else {return nil}
            return VirtualObject(url: url)
        }
    }()
}
