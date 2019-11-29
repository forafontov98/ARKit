//
//  ObjectPreview.swift
//  ARDemo
//
//  Created by Владислав Форафонтов on 27/11/2019.
//  Copyright © 2019 Владислав Форафонтов. All rights reserved.
//

import UIKit
import SceneKit

protocol VObjectProtocol {
    var object: SCNReferenceNode! { get set }
}

class VObject: VObjectProtocol {
    var object:     SCNReferenceNode!
    var texture:    UIImage?
    
    init(objPath: URL) {
        object = SCNReferenceNode(url: objPath)
    }
}
