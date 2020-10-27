//
//  StartupViewController.swift
//  DJISDKSwiftDemo
//
//  Created by DJI on 11/13/15.
//  Copyright © 2015 DJI. All rights reserved.
//

import UIKit
import DJISDK

class StartupViewController: UIViewController {

    weak var appDelegate: AppDelegate! = UIApplication.shared.delegate as? AppDelegate
    
    //@IBOutlet weak var productConnectionStatus: UILabel!
    @IBOutlet weak var productModel: UILabel!
    //@IBOutlet weak var productFirmwarePackageVersion: UILabel!
    @IBOutlet weak var openComponents: UIButton!
    @IBOutlet weak var bluetoothConnectorButton: UIButton!
    @IBOutlet weak var sdkVersionLabel: UILabel!
    @IBOutlet weak var bridgeModeLabel: UILabel!
    @IBOutlet weak var privacyPolicy: UIButton!
    
    @IBOutlet weak var fullbodyButton : UIButton!
    
    public var workoutName : String?
    
    private let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let connectedKey = DJIProductKey(param: DJIParamConnection) else {
            NSLog("Error creating the connectedKey")
            return;
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
            DJISDKManager.keyManager()?.startListeningForChanges(on: connectedKey, withListener: self, andUpdate: { (oldValue: DJIKeyedValue?, newValue : DJIKeyedValue?) in
                if newValue != nil {
                    if newValue!.boolValue {
                        // At this point, a product is connected so we can show it.
                        
                        // UI goes on MT.
                        DispatchQueue.main.async {
                            self.productConnected()
                        }
                    }
                }
            })
            DJISDKManager.keyManager()?.getValueFor(connectedKey, withCompletion: { (value:DJIKeyedValue?, error:Error?) in
                if let unwrappedValue = value {
                    if unwrappedValue.boolValue {
                        // UI goes on MT.
                        DispatchQueue.main.async {
                            self.productConnected()
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func onClickPrivacyPolicy(_ sender: AnyObject)
    {
        guard let url = URL(string: "https://www.termsfeed.com/live/5f5c3b70-1b1b-4d0c-ad91-1053bf019914") else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DJISDKManager.keyManager()?.stopAllListening(ofListeners: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //let temptag = (sender as! UIButton).tag
        //let tmpButton = self.view.viewWithTag(temptag)
        let workoutname = (sender as! UIButton).title(for: .normal)
        
        guard let viewCon = segue.destination as? ViewController else {return}
        viewCon.workoutname = workoutname
    }
    
    func resetUI() {
        self.title = "TUNA"
        self.sdkVersionLabel.text = "DJI SDK Version: \(DJISDKManager.sdkVersion())"
        self.openComponents.isEnabled = false; //FIXME: set it back to false
        self.bluetoothConnectorButton.isEnabled = true;
        //self.productConnectionStatus.isHidden = true;
        self.openComponents.isEnabled = true;
        self.productModel.isHidden = false
        //self.productFirmwarePackageVersion.isHidden = true
        //self.bridgeModeLabel.isHidden = !self.appDelegate.productCommunicationManager.enableBridgeMode
        
        if self.appDelegate.productCommunicationManager.enableBridgeMode {
            //self.bridgeModeLabel.text = "Bridge: \(self.appDelegate.productCommunicationManager.bridgeAppIP)"
        }
    }
    
    
    func showAlert(_ msg: String?) {
        // create the alert
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK : Product connection UI changes
    
    func productConnected() {
        guard let newProduct = DJISDKManager.product() else {
            NSLog("Product is connected but DJISDKManager.product is nil -> something is wrong")
            return;
        }

        //Updates the product's model
        self.productModel.text = "\((newProduct.model)!.uppercased())"
        self.productModel.isHidden = false
        
        //Updates the product's firmware version - COMING SOON
        newProduct.getFirmwarePackageVersion{ (version:String?, error:Error?) -> Void in
            
            /*self.productFirmwarePackageVersion.text = "Firmware Package Version: \(version ?? "Unknown")"
            
            if let _ = error {
                self.productFirmwarePackageVersion.isHidden = true
            }else{
                self.productFirmwarePackageVersion.isHidden = false
            }*/
            
            NSLog("Firmware package version is: \(version ?? "Unknown")")
        }
        
        //Updates the product's connection status
        //self.productConnectionStatus.text = "Status: Product Connected"
        
        self.openComponents.isEnabled = true;
        self.openComponents.alpha = 1.0;
        NSLog("Product Connected")
    }
    
    func productDisconnected() {
        //self.productConnectionStatus.text = "Status: No Product Connected"

        self.openComponents.isEnabled = true;
        self.openComponents.alpha = 0.8;
        NSLog("Product Disconnected")
    }
    
}





