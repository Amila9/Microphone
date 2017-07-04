import UIKit
import AVFoundation

class Details: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tbleView     : UITableView!
    let fileManager : FileManager = FileManager.default
    var recDirect : URL?
    var fileList : [String] = []
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbleView.dataSource     = self
        tbleView.delegate       = self
        
        do{
            let directoryContents = try fileManager.contentsOfDirectory( atPath: (recDirect?.path)!)
            print(directoryContents)
            self.fileList = directoryContents
        }catch {
            print  ("ERRROOOOORRRR")
        }
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! Cell
        cell.desc.text = fileList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertSound = recDirect?.appendingPathComponent("\(self.fileList[indexPath.row])")
        print(alertSound!)
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        try! audioPlayer = AVAudioPlayer(contentsOf: alertSound!)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
}

class Cell: UITableViewCell {
    
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
