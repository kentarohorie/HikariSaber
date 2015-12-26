import UIKit
import CoreMotion
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    var audioPlayer = AVAudioPlayer()
    var startAudioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setSound()
        setStartSound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getAccelerometer() {
        var preBool = false
        var postBool = false
        motionManager.accelerometerUpdateInterval = 1 / 5
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (accelerometerData: CMAccelerometerData?, error: NSError?) in
            
            guard error == nil else {
                return
            }
            
            let x = accelerometerData!.acceleration.x
            let y = accelerometerData!.acceleration.y
            let z = accelerometerData!.acceleration.z
            let synthetic = (x * x) + (y * y) + (z * z)

            if preBool {
                postBool = true
            }
            
            if !postBool && synthetic >= 6 {
                self.audioPlayer.currentTime = 0
                self.audioPlayer.play()

                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                preBool = true
            }
            
            if postBool && synthetic >= 6 {
                self.audioPlayer.currentTime = 0
                self.audioPlayer.play()
                
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                postBool = false
                preBool = false
            }
        }
    }
    
    func setSound() {
        let soundData = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("light_saber3", ofType: "mp3")!)
        audioPlayer = try! AVAudioPlayer(contentsOfURL: soundData)
        audioPlayer.prepareToPlay()
    }
    
    func setStartSound() {
        let soundData = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("electric_chain", ofType: "mp3")!)
        startAudioPlayer = try! AVAudioPlayer(contentsOfURL: soundData)
        startAudioPlayer.prepareToPlay()
    }
    
    //----------------------Set Up----------------------
    
    func setUp() {
        setButton()
    }
    
    func setButton() {
        let button = UIButton()
        button.frame.size = CGSize(width: 44, height: 44)
        button.center = view.center
        button.setTitle("Tap", forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.setTitleColor(UIColor.redColor(), forState: .Selected)
        button.addTarget(self, action: "tapButton:", forControlEvents: .TouchUpInside)
        view.addSubview(button)
    }
    
    func tapButton(sender: UIButton) {
        sender.selected = true
        setSound()
        startAudioPlayer.play()
        getAccelerometer()
    }
}

