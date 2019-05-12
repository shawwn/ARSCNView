//
//  ViewController.swift
//  ARSCNView
//
//  Created by Emily Kolar on 5/12/19.
//  Copyright © 2019 sweetiebird. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

  @IBOutlet weak var sceneView: ARSCNView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    sceneView.debugOptions = [.showWireframe, .showWorldOrigin, .showBoundingBoxes, .showSkeletons, .showFeaturePoints, .showLightInfluences]
    addTapGestureToSceneView()
    addBox()
  }

  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      let configuration = ARWorldTrackingConfiguration()
      sceneView.session.run(configuration)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      sceneView.session.pause()
  }
  
  func addTapGestureToSceneView() {
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
      sceneView.addGestureRecognizer(tapGestureRecognizer)
      let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.didPan(withGestureRecognizer:)))
      sceneView.addGestureRecognizer(panGestureRecognizer)
  }
  
  @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
      let tapLocation = recognizer.location(in: sceneView)
      let hitTestResults = sceneView.hitTest(tapLocation)
      let featureTestResults = sceneView.hitTest(tapLocation, types: ARHitTestResult.ResultType.featurePoint)
      guard let node = hitTestResults.first?.node else { 
        if let result = featureTestResults.first {
          addBox(result.worldTransform)
        }
        return
      }
      node.removeFromParentNode()
  }
  
  @objc func didPan(withGestureRecognizer recognizer: UIGestureRecognizer) {
      let tapLocation = recognizer.location(in: sceneView)
//      let hitTestResults = sceneView.hitTest(tapLocation)
      let featureTestResults = sceneView.hitTest(tapLocation, types: ARHitTestResult.ResultType.featurePoint)
//      guard let node = hitTestResults.first?.node else { 
        if var result = featureTestResults.first {
          for feature in featureTestResults {
            if feature.distance > result.distance {
              result = feature
            }
          }
          addBox(result.worldTransform)
        }
//        return
//      }
//      node.removeFromParentNode()
  }
  
  func addBox() {
    let box = SCNBox(width: 0.001, height: 0.001, length: 0.001, chamferRadius: 0)
    
    let boxNode = SCNNode()
    boxNode.geometry = box
    boxNode.opacity = 0.1
    boxNode.position = SCNVector3(0, 0, -0.2)
    
    let scene = SCNScene()
    scene.rootNode.addChildNode(boxNode)
    sceneView.scene = scene
  }
  
  func addBox(_ transform: simd_float4x4) {
    let box = SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0)
    
    let boxNode = SCNNode()
    boxNode.geometry = box
    boxNode.opacity = 0.1
    boxNode.position = SCNVector3(0, 0, 0)
    boxNode.simdTransform = transform
    
    sceneView.scene.rootNode.addChildNode(boxNode)
  }
  
  func addBox2() {
    let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
    
    let boxNode = SCNNode()
    boxNode.geometry = box
    boxNode.position = SCNVector3(0, 0, -0.2)
    
    sceneView.scene.rootNode.addChildNode(boxNode)
  }
}

