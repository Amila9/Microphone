

//Make sure to udate plist with Privacy – Microphone Usage Description && NSMicrophoneUsageDescription


import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    var audioRec: AVAudioRecorder?
    var audioPlayer = AVAudioPlayer()
    var audioUrl : URL?
    var docsDirect : URL?
    var recsDirect : URL?
    let fileManager : FileManager = FileManager.default
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        docsDirect = paths[0]
        
        recsDirect = docsDirect?.appendingPathComponent("Recordings")
        do {
            try FileManager.default.createDirectory(atPath: recsDirect!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        
        AVAudioSession.sharedInstance().requestRecordPermission () {
            [unowned self] allowed in
            if allowed {
                print ("Mic allowed")
                
            } else {
                print ("Mic NOT allowed")
            }
        }
    }
    
    @IBAction func record(_ sender: Any) {
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            // 2. configure the session for recording and playback
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            // 3. set up a high-quality recording session
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            // 4. create the audio recording, and assign ourselves as the delegate
            
            audioUrl = recsDirect?.appendingPathComponent("\(NSDate().description)")
            audioRec = try AVAudioRecorder(url: audioUrl!, settings: settings)
            audioRec?.delegate = self
            audioRec?.record()
            
            print("Recording Started....")
        }
        catch let e {
            // failed to record!
            print("Faliled to record Exception : \(e)")
        }
    }
    
    
    @IBAction func Stop(_ sender: Any) {
        print("Recording Stopped....")
        audioRec?.stop()
    }
    
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("recording ended : Unsuccessful")
        } else {
            print("recording ended : Successful")
        }
    }
    
    @IBAction func GO(_ sender: Any) {
        
        
        let nextView = self.storyboard?.instantiateViewController(withIdentifier: "Details") as? Details
        nextView?.recDirect = self.recsDirect!
        self.navigationController?.pushViewController(nextView!, animated: true)
        
        
    }
    
    
}

