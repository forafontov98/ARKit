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

    // MARK: - IBOutlets
    @IBOutlet var sceneView:        ARSCNView!
    @IBOutlet var collectionView:   UICollectionView!

    
    // MARK: - Variables
    var plane:          Plane?
    var object:         VObject?
    
    var settingsView:   SettingsView!
        
    let objects = [VObjectJSON(preview:  "Objects/Object1/Preview1.png",
                              object:   "Objects/Object1/Object1.scn",
                              texture:  "Objects/Object1/Texture1.jpg"),
                    VObjectJSON(preview:  "Objects/Object2/Preview2.png",
                    object:   "Objects/Object2/Object2.scn",
                    texture:  "Objects/Object2/Texture2.jpg"),
                    VObjectJSON(preview:  "Objects/Object1/Preview1.png",
                    object:   "Objects/Object1/Object1.scn",
                    texture:  "Objects/Object1/Texture1.jpg")]
    
    // MARK: - View Controller LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.showsStatistics =             false
        sceneView.autoenablesDefaultLighting =  true

        sceneView.scene = SCNScene()
        sceneView.delegate = self
        
        setupViewObjects()
        setupGestures()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // MARK: - IBActions

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
    
    @objc func placeVirtualObject(tapGesture: UITapGestureRecognizer) {
        let sceneView = tapGesture.view as! ARSCNView
        let location = tapGesture.location(in: sceneView)
        
        let hitTestResult = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        guard let hitRes = hitTestResult.first else {return}
        
        createVirtualObject(hitResult: hitRes, objScale: 0.035)
    }
    
    
    // MARK: - Functions
    
    func createVirtualObject(hitResult: ARHitTestResult, objScale: Double = 1.0) {
        
        object?.object.removeFromParentNode()
        
        let position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                  hitResult.worldTransform.columns.3.y,
                                  hitResult.worldTransform.columns.3.z)
        
        if let obj = object {
            let vObjBuilder = VObjectBuilder(obj)
            vObjBuilder.setPosition(pos: position, scale: objScale)
            
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.clear
            plane?.planeGeometry.materials = [material]
            
            sceneView.scene.rootNode.addChildNode(obj.object)
            
            vObjBuilder.setTexture(obj.texture)
        }
    }
    
    // создает particle system
    func create(particle: Weather?) {
        sceneView.scene.removeAllParticleSystems()

        /*
        guard virtualObj != nil, particle != nil else {return}
 
        if let particleSystem = SCNParticleSystem(named: particle!.nameParticle, inDirectory: nil) {
            if let childNode = virtualObj.childNode(withName: particle!.nameChildNode, recursively: true) {
                childNode.addParticleSystem(particleSystem)
            }
        } */
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
        
        sceneView.addGestureRecognizer(tapGestRec)
    }
    
    func loadObject(_ obj: VObjectJSON, completion: (()->())? = nil) {
        
        FirestorageHelper().downloadFile(obj.object) { data in
            
            if let fileName = obj.object.components(separatedBy: "/").last {
                let path = FileHelper.shared.objectsPath + "/\(fileName)"

                FileHelper.shared.save(data, to: path)
                
                self.object = VObject(objPath: URL(fileURLWithPath: path))
                
                FirestorageHelper().downloadFile(obj.texture) { data in
                    if let image = UIImage(data: data) {
                        
                        if let fileName = obj.texture.components(separatedBy: "/").last {
                            let path = FileHelper.shared.objectsPath + "/\(fileName)"
                            FileHelper.shared.save(data, to: path)
                        }
                        
                        self.object?.texture = image
                        if let completion = completion {
                            completion()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        
        plane?.removeFromParentNode()
        
        plane = Plane(anchor: anchor as! ARPlaneAnchor)
        node.addChildNode(plane!)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard plane != nil else {return}
        
        if let anchor = anchor as? ARPlaneAnchor {
            plane?.update(anchor: anchor)
        }
    }
}

// MARK: - Extensions
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "previewCell", for: indexPath)
        
        if let cell = cell as? PreviewCVCProtocol {
            
            let previewPath = objects[indexPath.row].preview
            
            cell.startLoading()
            FirestorageHelper().downloadFile(previewPath) { data in
                if let image = UIImage(data: data) {
                    cell.config(image: image)
                    
                    cell.stopLoading()
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = objects[indexPath.row]
        
        if let cell = collectionView.cellForItem(at: indexPath) as? PreviewCVCProtocol {
            
            cell.startLoading()
            loadObject(obj) {
                cell.stopLoading()
            }
        }
    }
}
