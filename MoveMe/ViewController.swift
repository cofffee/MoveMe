//
//  ViewController.swift
//  MoveMe
//
//  Created by Remigio, Kevin (Contractor) on 7/21/17.
//  Copyright © 2017 Remigio, Kevin (Contractor). All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var imageView: UIImageView? = nil
    let manager = CMMotionManager()
    var toggle: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame: CGRect = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        imageView = UIImageView(frame: frame)
        imageView?.image = UIImage(named: "a")
        
        view.addSubview(imageView!)
        
        var isHardwareActive = manager.isAccelerometerActive
        isHardwareActive = manager.isGyroActive
        isHardwareActive = manager.isMagnetometerActive
        isHardwareActive = manager.isDeviceMotionActive
        
        useAccelerometer()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapImage(_:)))
        imageView?.addGestureRecognizer(tapGesture)
        imageView?.isUserInteractionEnabled = true
        
        
    }
    
    func tapImage(_ sender: UITapGestureRecognizer) {
        print("Please Help!")
        if toggle == true {
            manager.stopAccelerometerUpdates()
            toggle = false
        } else {
            useAccelerometer()
            toggle = true
        }
        
    }
    func useGyro() {
        manager.startGyroUpdates(to: OperationQueue(), withHandler: {
            (accelerometerData, error) in

            let rotation = atan2((accelerometerData?.rotationRate.x)!,(accelerometerData?.rotationRate.y)!) - Double.pi
            DispatchQueue.main.async {
                self.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
            }
            
        })
    
    }
    func useDeviceMotion() {
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.1
            manager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: { [weak self] (data: CMDeviceMotion?, error: Error?) in
                
                let rotation = atan2((data?.rotationRate.x)!,(data?.rotationRate.y)!) - Double.pi
                DispatchQueue.main.async {
                    self?.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                }
            })
        }
    }
    func useAccelerometer() {
        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = 0.1
            manager.startAccelerometerUpdates(to: OperationQueue(), withHandler: { [weak self] (data: CMAccelerometerData?, error: Error?) in
                
                if let acceleration = data?.acceleration {
                    let rotation = atan2(acceleration.x, acceleration.y) - Double.pi
                    DispatchQueue.main.async {
                        self?.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                    }
                    
                }
            })
        }
    }


}

