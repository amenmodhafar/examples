// Copyright 2019 The TensorFlow Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import AVFoundation
import UIKit
import os
import DJISDK
import DJISDK.DJIGimbal

class ViewController: UIViewController {
  // MARK: Storyboards Connections
  @IBOutlet weak var previewView: PreviewView!

  @IBOutlet weak var overlayView: OverlayView!

    @IBOutlet weak var StackView: UIStackView!
    
    @IBOutlet weak var StackView1: UIStackView!
    
    @IBOutlet weak var BottomView: UIStackView!

  @IBOutlet weak var resumeButton: UIButton!
  @IBOutlet weak var cameraUnavailableLabel: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!

  //@IBOutlet weak var tableView: UITableView!

  //@IBOutlet weak var threadCountLabel: UILabel!
  //@IBOutlet weak var threadCountStepper: UIStepper!

  //@IBOutlet weak var delegatesControl: UISegmentedControl!
    
  @IBOutlet weak var bluetoothConnectorButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var workTime: UILabel!
    @IBOutlet weak var uiCounter: UILabel!

  // MARK: ModelDataHandler traits
  var threadCount: Int = Constants.defaultThreadCount
  var delegate: Delegates = Constants.defaultDelegate

  // MARK: Result Variables
  // Inferenced data to render.
  private var inferencedData: InferencedData?

  // Minimum score to render the result.
  private var minimumScore: Float = 0.5

  // Relative location of `overlayView` to `previewView`.
  private var overlayViewFrame: CGRect?

  private var previewViewFrame: CGRect?

  // MARK: Controllers that manage functionality
  // Handles all the camera related functionality
  private lazy var cameraCapture = CameraFeedManager(previewView: previewView)

  // Handles all data preprocessing and makes calls to run inference.
  private var modelDataHandler: ModelDataHandler?
    
    private var gimbalController: GimbalViewController = GimbalViewController()
  //private var speaker : SpeechViewController?
    
  private let synth = AVSpeechSynthesizer()
  private var myUtterance = AVSpeechUtterance(string: "")
    
    public var workoutRoutine = [workoutSet]()
    public var workoutname: String?
    private var schema: Schema?
    private var exerciseNames: [String]?
    private var workoutDisplayName : String = ""
    
    private var startTime = NSDate.timeIntervalSinceReferenceDate
    private var everyStartTime = NSDate.timeIntervalSinceReferenceDate
    private var elapsedTimeDisplay: String = ""
    private var workTimeDisplay: String = ""


  private var centerPoint: CGPoint = CGPoint(x:200.0,y: 160.0)
  private var distance: CGFloat = CGFloat(0.0)
     private var distance1: CGFloat = CGFloat(0.0)
    private var homeFlag: Bool = false
    private var awayFlag: Bool = false
    private var backhomeFlag: Bool = false
    private var awayFlag1: Bool = false
    private var backhomeFlag1: Bool = false
    private let thresholdDist: CGFloat = CGFloat(30.0)
    private var repCount: Double = 0.0
    private var numSet: Double = 1.0
    private var backwardStep: Double = 0.0
    private var isCounting: Bool = false
    private var maxReps: Double = 10
    private var countBuffer: Double = 0
    private var countBuffer1: Double = 0
    private var uiCount: Double = 0
    private var uiBuffer: Double = 2
    private var aiRoute: Double = 0
    
    
    struct workoutSet: Codable{
        var numRepsJSON: Double
        var numSetsJSON: Double
        var elapsedTimeJSON: String
        var workoutTimeJSON: String
        var workoutNameJSON: String
        var workoutDateJSON: String
        var routineNameJSON: String
        
        /*public init(_numReps: Double ,_numSets: Double, _elapsedTime: String,
                               _workoutTime: String, _workoutName: String, _workoutDate: String, _routineName: String)
        {
            numRepsJSON = _numReps
            numSetsJSON = _numSets
            elapsedTimeJSON = _elapsedTime
            workoutTimeJSON = _workoutTime
            workoutNameJSON = _workoutName
            workoutDateJSON = _workoutDate
            routineNameJSON = _routineName
        }*/
        
    }
  // MARK: View Handling Methods
  override func viewDidLoad() {
    super.viewDidLoad()

    do {
      modelDataHandler = try ModelDataHandler()
    } catch let error {
      fatalError(error.localizedDescription)
    }

    cameraCapture.delegate = self

    self.bluetoothConnectorButton.isEnabled = true
    
    schema = Schema.init().self
    
    schema!.createSuperSet(workoutname!)
    
    exerciseNames = schema!.workoutNames
    
    workoutDisplayName =
        (schema?.getCurrentExerName(numSet))!
    
    textToSpeech("Let's work out: " + workoutname!)
    
    compensationFactors()
  }
    
    func updateTime(intervalBeginning: TimeInterval) -> String
  {
    let currentTime = NSDate.timeIntervalSinceReferenceDate
    
    var elapsedTime:TimeInterval = currentTime - intervalBeginning
    
    //calculate the minutes in elapsed time.

    let minutes = UInt8(elapsedTime / 60.0)

    elapsedTime -= (TimeInterval(minutes) * 60)

    //calculate the seconds in elapsed time.

    let seconds = UInt8(elapsedTime)

    elapsedTime -= TimeInterval(seconds)

    //add the leading zero for minutes, seconds and millseconds and store them as string constants

    let strMinutes = String(format: "%02d", minutes)
    let strSeconds = String(format: "%02d", seconds)
    
    return "\(strMinutes):\(strSeconds)"
    
  }
    
    
  func checkToSwitch()
  {
    if ((modelDataHandler?.pResults.score)! >= 0.5)
    {
        let wristR = modelDataHandler?.pResults.dots[10]
        let wristL = modelDataHandler?.pResults.dots[9]
        
        let elbowR = modelDataHandler?.pResults.dots[8]
        let elbowL = modelDataHandler?.pResults.dots[7]
        
        distance = abs(wristR!.y - wristL!.y)

        if (wristR!.y < elbowR!.y && wristL!.y < elbowL!.y && !isCounting && distance < thresholdDist )
        {
            isCounting = true
            textToSpeech("Let's Go: " + (schema?.getCurrentExerName(numSet - backwardStep))!)
            
            DispatchQueue.main.async {
                self.playButton.setImage(UIImage(named: "stop_button.png")!, for: .normal)
            }
            
        }
        else if (repCount == maxReps && isCounting )
        {
            saveSet()
            
            repCount = 0
            numSet += 1
            workoutDisplayName = (schema?.getCurrentExerName(numSet - backwardStep))!
            textToSpeech("Great Work! Up next is " + workoutDisplayName)
            
            DispatchQueue.main.async {
                self.playButton.setImage(UIImage(named: "play_button.png")!, for: .normal)
            }
            
            compensationFactors()
            
            isCounting = false
        }
    }
  }

  func compensate()
  {
    if ((modelDataHandler?.pResults.score)! >= 0.3)
    {
        if (isCounting)
        {
            let pt = modelDataHandler?.pResults.dots[0]

            let Dist_x = pt!.x - centerPoint.x
            let Dist_y = pt!.y - centerPoint.y

            if (Dist_x > thresholdDist * 3.0 )
            {
                gimbalController.MoveGimbalWithSpeed(pitch: 0, yaw: -5.5,roll: 0,delay: 0.3)
            }
            else if (Dist_x < -thresholdDist * 3.0 )
            {
                gimbalController.MoveGimbalWithSpeed(pitch: 0, yaw: 5.5,roll: 0,delay: 0.3)
            }

            if (Dist_y > thresholdDist * 4.0 )
            {
                gimbalController.MoveGimbalWithSpeed(pitch: -5.5, yaw: 0,roll: 0,delay: 0.5)
            }
            else if (Dist_y < -thresholdDist * 2.5 )
            {
                gimbalController.MoveGimbalWithSpeed(pitch: 5.5, yaw: 0,roll: 0,delay: 0.3)
            }
        }
        else
        {
            let pt = modelDataHandler?.pResults.dots[0]

            let Dist_x = pt!.x - centerPoint.x
            let Dist_y = pt!.y - centerPoint.y

            if (Dist_x > thresholdDist * 1.5 )
            {
                gimbalController.MoveGimbalWithSpeed(pitch: 0, yaw: -4.5,roll: 0,delay: 0.5)
            }
            else if (Dist_x < -thresholdDist * 1.5 )
            {
                gimbalController.MoveGimbalWithSpeed(pitch: 0, yaw: 4.5,roll: 0,delay: 0.5)
            }

            if (Dist_y > thresholdDist * 1.5 )
            {
                gimbalController.MoveGimbalWithSpeed(pitch: -4.5, yaw: 0,roll: 0,delay: 0.5)
            }
            else if (Dist_y < -thresholdDist * 1.5 )
            {
                gimbalController.MoveGimbalWithSpeed(pitch: 4.5, yaw: 0,roll: 0,delay: 0.5)
            }
        }
    }
  }

  func compensationFactors()
  {
    if (workoutname!.lowercased().contains("arm") || workoutname!.lowercased().contains("shoulder") ||
        workoutname!.lowercased().contains("boxing") || workoutname!.lowercased().contains("tennis") ||
        workoutname!.lowercased().contains("golf") || workoutDisplayName.lowercased().contains("press")){
        aiRoute = 1
        minimumScore = 0.5
        maxReps = 40
    }
    else if (workoutDisplayName.lowercased().contains("push"))
    {
        aiRoute = 0
        minimumScore = 0.3
        maxReps = 20
    }
        
    else {
        aiRoute = 0
        minimumScore = 0.5
        maxReps = 16
    }
  }
    
  func countController()
  {
    checkToSwitch()
    
    if (isCounting)
    {
        if (aiRoute == 1){
            count(bodypart: 9)
        }
        else {
            count(bodypart: 0)
        }

    }
    
    updateUI()
    
  }
    
  func updateUI()
  {
    uiCount += 1
    
    
    if (uiCount >= uiBuffer)
    {
        if (isCounting)
        {
            workTimeDisplay = updateTime(intervalBeginning: everyStartTime)
            
            DispatchQueue.main.sync {
            self.workTime.text =  workTimeDisplay
            }
            
        }
    
        elapsedTimeDisplay = updateTime(intervalBeginning: startTime)
        
        DispatchQueue.main.sync {
            self.elapsedTime.text = elapsedTimeDisplay
            self.uiCounter.text = "\(String(format: "%.0f", repCount))"
            
            let title = "\(String(format: "%.0f", numSet)) \(String("- ")) \(workoutDisplayName.uppercased())"
            self.titleLabel.text = title
        }
        
        uiCount = 0
    }
  }
    
  func count(bodypart: Int)
  {
    
    if ((modelDataHandler?.pResults.score)! >= minimumScore)
    {
        if (aiRoute == 0)
        {
            let pt = modelDataHandler?.pResults.dots[bodypart]
            
            distance = sqrt(pow(pt!.x - centerPoint.x,2) + pow(pt!.y - centerPoint.y,2))
            
            if (distance < thresholdDist * 1.5 && !awayFlag && !homeFlag && !backhomeFlag)
            {
                homeFlag = true
                
                NSLog("Found Home")
            }
            
            if (distance > thresholdDist * 1.5 && !awayFlag && homeFlag)
            {
                awayFlag = true
                backhomeFlag = false
                homeFlag = false
                
                NSLog("Moved Away From Home")
            }
            
                if (distance < thresholdDist * 1.5 && awayFlag)
            {
                backhomeFlag = true
                
                NSLog("Moved Back Home")
            }
            
            if (distance < thresholdDist * 1.5 && awayFlag && backhomeFlag)
            {
                repCount = repCount + 1.0
                homeFlag = false
                backhomeFlag = false
                awayFlag = false
                
                textToSpeech(String(format: "%.0f", repCount))
                
                NSLog("Rep: " + String(format: "%.0f", repCount))
            }
        }
        else
        {
            
            let pt = modelDataHandler?.pResults.dots[bodypart]
            let pt1 = modelDataHandler?.pResults.dots[bodypart+1]
            
            distance = sqrt(pow(pt!.x - centerPoint.x,2) + pow(pt!.y - centerPoint.y,2))
            distance1 = sqrt(pow(pt1!.x - centerPoint.x,2) + pow(pt1!.y - centerPoint.y,2))
            
            if (countBuffer >= uiBuffer)
            {
                if (distance > thresholdDist * 1.5 && !awayFlag)
                {
                    awayFlag = true
                    backhomeFlag = false
                }
                
                if (distance < thresholdDist * 1.5 && awayFlag )
                {
                    backhomeFlag = true
                }
                
                if (distance < thresholdDist * 1.5 && awayFlag && backhomeFlag)
                {
                    repCount = repCount + 1.0
                    backhomeFlag = false
                    awayFlag = false
                    
                    textToSpeech(String(format: "%.0f", repCount))
                    
                    NSLog("Rep: " + String(format: "%.0f", repCount))
                    
                }
                
                countBuffer = 0
            }
            
            countBuffer += 1
            
            if (countBuffer1 >= uiBuffer)
            {
                if (distance1 > thresholdDist * 1.5 && !awayFlag1)
                {
                    awayFlag1 = true
                    backhomeFlag1 = false
                }
                
                if (distance1 < thresholdDist * 1.5 && awayFlag1 )
                {
                    backhomeFlag1 = true
                }
                
                if (distance1 < thresholdDist * 1.5 && awayFlag1 && backhomeFlag1)
                {
                    repCount = repCount + 1.0
                    backhomeFlag1 = false
                    awayFlag1 = false
                    
                    textToSpeech(String(format: "%.0f", repCount))
                    
                    NSLog("Rep: " + String(format: "%.0f", repCount))
                    
                }
                
                countBuffer1 = 0
            }
            
            countBuffer1 += 1
            
        }
    }

  }
    
  func textToSpeech(_ text: String)
  {
     if (synth.isSpeaking)
     {
        synth.stopSpeaking(at: AVSpeechBoundary.word)
     }
    
      myUtterance = AVSpeechUtterance(string: text)
      myUtterance.rate = 0.4
      synth.speak(myUtterance)
      
      return;
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    cameraCapture.checkCameraConfigurationAndStartSession()
    
  }

  override func viewWillDisappear(_ animated: Bool) {
    cameraCapture.stopSession()
    
    saveTotal()
    
    textToSpeech("Ending Workout")
  }

  override func viewDidLayoutSubviews() {
    overlayViewFrame = overlayView.frame
    previewViewFrame = previewView.frame
  }

  //
    
    @IBAction func didClickPlay(_ sender: UIButton)
    {
        if (isCounting)
        {
            saveSet()
            
            isCounting = false
            numSet += 1
            repCount = 0
            workoutDisplayName = (schema?.getCurrentExerName(numSet - backwardStep))!
            textToSpeech("Take a break")
            
            playButton.setImage(UIImage(named: "play_button.png")!, for: .normal)
            
            compensationFactors()
        }
        else
        {
            isCounting = true
            workoutDisplayName = (schema?.getCurrentExerName(numSet - backwardStep))!
            textToSpeech("Let's do some: " + (workoutDisplayName))

            playButton.setImage(UIImage(named: "stop_button.png")!, for: .normal)
            everyStartTime = NSDate.timeIntervalSinceReferenceDate
        }
    }
    
    @IBAction func didPlusClick(_ sender: UIButton)
    {
        repCount += 1
        
    }
    
    @IBAction func didMinusClick(_ sender: UIButton)
    {
        if (repCount >= 1)
        {
            repCount -= 1
        }
    }
    
    @IBAction func didClickForwards(_ sender: UIButton)
    {
        saveSet()
        
        numSet += 1
        repCount = 0
        isCounting = true
        workoutDisplayName = (schema?.getCurrentExerName(numSet - backwardStep))!
        textToSpeech("Move to: " + workoutDisplayName )
        everyStartTime = NSDate.timeIntervalSinceReferenceDate
        
        self.playButton.setImage(UIImage(named: "stop_button.png")!, for: .normal)
        
        compensationFactors()
    }
    
    @IBAction func didClickBackwards(_ sender: UIButton)
    {
        saveSet()
        
        numSet += 1
        backwardStep += 2
        repCount = 0
        isCounting = true
        workoutDisplayName = (schema?.getCurrentExerName(numSet - backwardStep))!
        textToSpeech("Back to: " + workoutDisplayName )
        everyStartTime = NSDate.timeIntervalSinceReferenceDate
        
        self.playButton.setImage(UIImage(named: "stop_button.png")!, for: .normal)
        
        compensationFactors()
    }

  @IBAction func didTapResumeButton(_ sender: Any) {
    cameraCapture.resumeInterruptedSession { complete in

      if complete {
        self.resumeButton.isHidden = true
        self.cameraUnavailableLabel.isHidden = true
      } else {
        self.presentUnableToResumeSessionAlert()
      }
    }
  }

  func saveTotal()
  {
    let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    //let usLocale = Locale(identifier: "en_US")
    
    let dateFormatter : DateFormatter = DateFormatter()
    //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.dateFormat = "yyyy-MMM-dd"
    let date = Date()
    let workoutDate = dateFormatter.string(from: date)
    
    let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString + "/Tuna/" + workoutDate)!

     let fileManager1 = FileManager.default
    var isDirectory1: ObjCBool = true
    
    if !fileManager1.fileExists(atPath: (documentsDirectoryPath.absoluteString)!, isDirectory: &isDirectory1) {
        
        do {
            try fileManager1.createDirectory(atPath: (documentsDirectoryPath.absoluteString)!, withIntermediateDirectories: true, attributes: nil)
            print("Directory created")
        } catch let error as NSError
        {
            print (error.localizedDescription)
        }
        
    } else {
        print("Directory already exists")
    }
    
    let subfile =  String(workoutname!) + "-" + ".json"
    let fileName = String(Int(numSet)) + "-" + subfile
    let jsonFilePath = documentsDirectoryPath.appendingPathComponent(fileName, isDirectory: false)
    let fileManager = FileManager.default
    var isDirectory: ObjCBool = false

    
    let absolutepath  = jsonFilePath!.absoluteString
    // creating a .json file in the Documents folder
    if (!absolutepath.isEmpty)
    {
    if !fileManager.fileExists(atPath: absolutepath, isDirectory: &isDirectory) {
        let created = fileManager.createFile(atPath: absolutepath, contents: nil, attributes: nil)
        if created {
            print("File created ")
        } else {
            print("Couldn't create file")
        }
    } else {
        print("File already exists")
    }
    } else {
        print("Path is invalid")
    }
    
    let jsonEncoder = JSONEncoder()
    do {
        
        let jsonData =  try jsonEncoder.encode(workoutRoutine)
        
        // Write that JSON to the file created earlier
        do {
            let file = FileHandle(forWritingAtPath: absolutepath)
            file?.write(jsonData)
            print("JSON data was written to file successfully!")
        }
    } catch let error as NSError {
        print("Couldn't encode to file: \(error.localizedDescription)")
    }
    
  }
  func saveSet()
  {
    let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    //let usLocale = Locale(identifier: "en_US")
    
    let dateFormatter : DateFormatter = DateFormatter()
    //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.dateFormat = "yyyy-MMM-dd"
    let date = Date()
    let workoutDate = dateFormatter.string(from: date)
    
    let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString + "/Tuna/" + workoutDate)!

     let fileManager1 = FileManager.default
    var isDirectory1: ObjCBool = true
    
    if !fileManager1.fileExists(atPath: (documentsDirectoryPath.absoluteString)!, isDirectory: &isDirectory1) {
        
        do {
            try fileManager1.createDirectory(atPath: (documentsDirectoryPath.absoluteString)!, withIntermediateDirectories: true, attributes: nil)
            print("Directory created")
        } catch let error as NSError
        {
            print (error.localizedDescription)
        }
        
    } else {
        print("Directory already exists")
    }
    
    let subsub = workoutDisplayName + "-" + String(Int(repCount)) + ".json"
    let subfile =  String(workoutname!) + "-" + subsub
    let fileName = String(Int(numSet)) + "-" + subfile
    let jsonFilePath = documentsDirectoryPath.appendingPathComponent(fileName, isDirectory: false)
    let fileManager = FileManager.default
    var isDirectory: ObjCBool = false

    
    let absolutepath  = jsonFilePath!.absoluteString
    // creating a .json file in the Documents folder
    if (!absolutepath.isEmpty)
    {
    if !fileManager.fileExists(atPath: absolutepath, isDirectory: &isDirectory) {
        let created = fileManager.createFile(atPath: absolutepath, contents: nil, attributes: nil)
        if created {
            print("File created ")
        } else {
            print("Couldn't create file")
        }
    } else {
        print("File already exists")
    }
    } else {
        print("Path is invalid")
    }
    
    let jsonEncoder = JSONEncoder()
    do {
        let _workoutSet = workoutSet(numRepsJSON: repCount, numSetsJSON: numSet, elapsedTimeJSON: elapsedTimeDisplay, workoutTimeJSON: workTimeDisplay, workoutNameJSON: workoutDisplayName, workoutDateJSON: workoutDate, routineNameJSON: workoutname!)
        
        workoutRoutine.append(_workoutSet)
        
        let jsonData =  try jsonEncoder.encode(_workoutSet)
        
        // Write that JSON to the file created earlier
        do {
             //_ =  String(data: jsonData, encoding: String.Encoding.utf16)
            let file = FileHandle(forWritingAtPath: absolutepath)
            file?.write(jsonData)
            print("JSON data was written to file successfully!")
        }
    } catch let error as NSError {
        print("Couldn't encode to file: \(error.localizedDescription)")
    }
    
    
  }
    
  func presentUnableToResumeSessionAlert() {
    let alert = UIAlertController(
      title: "Unable to Resume Session",
      message: "There was an error while attempting to resume session.",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

    self.present(alert, animated: true)
    
    
  }
}


// MARK: - CameraFeedManagerDelegate Methods
extension ViewController: CameraFeedManagerDelegate {
  func cameraFeedManager(_ manager: CameraFeedManager, didOutput pixelBuffer: CVPixelBuffer) {
    runModel(on: pixelBuffer)
    
    compensate()
    
    countController()
    
  }

  // MARK: Session Handling Alerts
  func cameraFeedManagerDidEncounterSessionRunTimeError(_ manager: CameraFeedManager) {
    // Handles session run time error by updating the UI and providing a button if session can be
    // manually resumed.
    self.resumeButton.isHidden = false
  }

  func cameraFeedManager(
    _ manager: CameraFeedManager, sessionWasInterrupted canResumeManually: Bool
  ) {
    // Updates the UI when session is interupted.
    if canResumeManually {
      self.resumeButton.isHidden = false
    } else {
      self.cameraUnavailableLabel.isHidden = false
    }
  }

  func cameraFeedManagerDidEndSessionInterruption(_ manager: CameraFeedManager) {
    // Updates UI once session interruption has ended.
    self.cameraUnavailableLabel.isHidden = true
    self.resumeButton.isHidden = true
  }

  func presentVideoConfigurationErrorAlert(_ manager: CameraFeedManager) {
    let alertController = UIAlertController(
      title: "Confirguration Failed", message: "Configuration of camera has failed.",
      preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(okAction)

    present(alertController, animated: true, completion: nil)
  }

  func presentCameraPermissionsDeniedAlert(_ manager: CameraFeedManager) {
    let alertController = UIAlertController(
      title: "Camera Permissions Denied",
      message:
        "Camera permissions have been denied for this app. You can change this by going to Settings",
      preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { action in
      if let url = URL.init(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }

    alertController.addAction(cancelAction)
    alertController.addAction(settingsAction)

    present(alertController, animated: true, completion: nil)
  }

  @objc func runModel(on pixelBuffer: CVPixelBuffer) {
    guard let overlayViewFrame = overlayViewFrame, let previewViewFrame = previewViewFrame
    else {
      return
    }
    // To put `overlayView` area as model input, transform `overlayViewFrame` following transform
    // from `previewView` to `pixelBuffer`. `previewView` area is transformed to fit in
    // `pixelBuffer`, because `pixelBuffer` as a camera output is resized to fill `previewView`.
    // https://developer.apple.com/documentation/avfoundation/avlayervideogravity/1385607-resizeaspectfill
    let modelInputRange = overlayViewFrame.applying(
      previewViewFrame.size.transformKeepAspect(toFitIn: pixelBuffer.size))

    // Run PoseNet model.
    guard
      let (result, times) = self.modelDataHandler?.runPoseNet(
        on: pixelBuffer,
        from: modelInputRange,
        to: overlayViewFrame.size)
    else {
      os_log("Cannot get inference result.", type: .error)
      return
    }

    // Udpate `inferencedData` to render data in `tableView`.
    inferencedData = InferencedData(score: result.score, times: times)

    //count();
    
    // Draw result.
    DispatchQueue.main.async {
      //self.tableView.reloadData()
      // If score is too low, clear result remaining in the overlayView.
      if result.score < self.minimumScore {
        self.clearResult()
        return
      }
      self.drawResult(of: result)
    }
  }

  func drawResult(of result: Result) {
    self.overlayView.dots = result.dots
    self.overlayView.lines = result.lines
    self.overlayView.setNeedsDisplay()
  }

  func clearResult() {
    self.overlayView.clear()
    self.overlayView.setNeedsDisplay()
  }
}

// MARK: - TableViewDelegate, TableViewDataSource Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return InferenceSections.allCases.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = InferenceSections(rawValue: section) else {
      return 0
    }

    return section.subcaseCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoCell
    guard let section = InferenceSections(rawValue: indexPath.section) else {
      return cell
    }
    guard let data = inferencedData else { return cell }

    var fieldName: String
    var info: String

    switch section {
    case .Score:
      fieldName = section.description
      info = String(format: "%.1f", distance)
    case .Time:
      guard let row = ProcessingTimes(rawValue: indexPath.row) else {
        return cell
      }
      var time: Double
      switch row {
      case .InferenceTime:
        time = data.times.inference
      }
      fieldName = row.description
      info = String(format: "%.2fms", time)
    }

    cell.fieldNameLabel.text = fieldName
    cell.infoLabel.text = info

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let section = InferenceSections(rawValue: indexPath.section) else {
      return 0
    }

    var height = Traits.normalCellHeight
    if indexPath.row == section.subcaseCount - 1 {
      height = Traits.separatorCellHeight + Traits.bottomSpacing
    }
    return height
  }

}

// MARK: - Private enums
/// UI coinstraint values
fileprivate enum Traits {
  static let normalCellHeight: CGFloat = 35.0
  static let separatorCellHeight: CGFloat = 25.0
  static let bottomSpacing: CGFloat = 30.0
}

fileprivate struct InferencedData {
  var score: Float
  var times: Times
}

/// Type of sections in Info Cell
fileprivate enum InferenceSections: Int, CaseIterable {
  case Score
  case Time

  var description: String {
    switch self {
    case .Score:
      return "Score"
    case .Time:
      return "Processing Time"
    }
  }

  var subcaseCount: Int {
    switch self {
    case .Score:
      return 1
    case .Time:
      return ProcessingTimes.allCases.count
    }
  }
}

/// Type of processing times in Time section in Info Cell
fileprivate enum ProcessingTimes: Int, CaseIterable {
  case InferenceTime

  var description: String {
    switch self {
    case .InferenceTime:
      return "Inference Time"
    }
  }
}
