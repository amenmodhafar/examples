//
//  GimbalViewController.swift
//  PoseNet
//
//  Created by Apple  on 2020-10-26.
//  Copyright © 2020 tensorflow. All rights reserved.
//

import Foundation
import DJISDK
import DJISDK.DJIGimbal
import DJISDK.DJIBaseProduct
import DJISDK.DJIBaseComponent
import DJISDK.DJIHandheld

public class GimbalViewController{
    

    private var gimbalRotation:DJIGimbalRotation?
    
    public func GimbalViewController()
    {
        initGimbal()
        gimbalRotation = DJIGimbalRotation.init();
        
    }
    
    private func initGimbal(){

        if (DJISDKManager.product() != nil){
            DJISDKManager.product()!.gimbal!.setMotorEnabled(true)
        }
    }
    
    public func MoveGimbalWithSpeed(pitch: NSNumber, yaw: NSNumber, roll: NSNumber, delay: Double){
        
        gimbalRotation = DJIGimbalRotation.init(pitchValue: pitch, rollValue: roll, yawValue: yaw, time: delay, mode: DJIGimbalRotationMode.relativeAngle, ignore: true)
        
        if (DJISDKManager.product() != nil){
            DJISDKManager.product()!.gimbal!.rotate(with: gimbalRotation!, completion: { (NSError) in
                return;
            })
        }
        
    }
}
