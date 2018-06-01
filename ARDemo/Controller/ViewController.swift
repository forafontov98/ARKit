//
//  ViewController.swift
//  ARDemo
//
//  Created by Владислав Форафонтов on 26.02.2018.
//  Copyright © 2018 Владислав Форафонтов. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    var planes = [Plane]()
    var virtualObj: SCNReferenceNode!
    var settingsView: SettingsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = true

        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.delegate = self
        
        setupViewObjects()
        setupGestures()
    }
    
    // нажатие на кнопку "Настройки"
    @IBAction func settingsBtnPressed(_ sender: Any) {
        var offset: CGFloat!
        if settingsView.isShowen {
            offset = -settingsView.bounds.width
        } else {
            offset = settingsView.bounds.width
        }
        
        settingsView.isShowen = !settingsView.isShowen
        
        UIView.animate(withDuration: 0.3, animations: {
            self.settingsView.center.x += offset
        })
    }
    
    // отвечает за настройку всех элементов view
    func setupViewObjects() {
        settingsView = SettingsView(frame: CGRect(x: -view.bounds.width / 2, y: 0.0, width: view.bounds.width / 2, height: view.bounds.height))
        view.addSubview(settingsView)
        settingsView.myDelegate = self
    }
    
    // устанавливает жесты
    func setupGestures() {
        let tapGestRec = UITapGestureRecognizer(target: self, action: #selector(placeVirtualObject))
        tapGestRec.numberOfTapsRequired = 1
        self.sceneView.addGestureRecognizer(tapGestRec)
    }
    
    @objc func placeVirtualObject(tapGesture: UITapGestureRecognizer) {
        let sceneView = tapGesture.view as! ARSCNView
        let location = tapGesture.location(in: sceneView)
        
        let hitTestResult = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        guard let hitRes = hitTestResult.first else {return}
        
        createVirtualObject(hitResult: hitRes, objScale: 0.035)
    }
    
    func createVirtualObject(hitResult: ARHitTestResult, objScale: Double = 1.0) {
        let position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                  hitResult.worldTransform.columns.3.y,
                                  hitResult.worldTransform.columns.3.z)
        let virtualObject = VirtualObject.availableObjects[1]
        virtualObject.position = position
        virtualObject.scale = SCNVector3(objScale, objScale, objScale)
        virtualObject.load()
        virtualObj = virtualObject

        for plane in planes {
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.clear
            plane.planeGeometry.materials = [material]
        }
        
        sceneView.scene.rootNode.addChildNode(virtualObject)
    }
    
    // создает particle system
    func create(particle: Weather?) {
        sceneView.scene.removeAllParticleSystems()

        guard virtualObj != nil, particle != nil else {return}
 
        if let particleSystem = SCNParticleSystem(named: particle!.nameParticle, inDirectory: nil) {
            if let childNode = virtualObj.childNode(withName: particle!.nameChildNode, recursively: true) {
                childNode.addParticleSystem(particleSystem)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
