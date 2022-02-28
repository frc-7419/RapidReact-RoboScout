import UIKit

class AutonViewController: UIViewController {

    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var lowerLabel: UILabel!
    @IBOutlet weak var updateScore: UILabel!
    @IBOutlet weak var lowerHubStepper: UIStepper!
    @IBOutlet weak var upperHubStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        updateScore.text = "0"
        updateScore.text = String(describing: global.autonData["totalScore"]!)
        lowerLabel.text = String(describing: global.autonData["lowerScore"]!)
        upperLabel.text = String(describing: global.autonData["upperScore"]!)
        lowerHubStepper.value = Double(String(describing: global.autonData["lowerScore"]!)) ?? 0.0
        upperHubStepper.value = Double(String(describing: global.autonData["upperScore"]!)) ?? 0.0
    }
    var didMoveOff = false
    var totalScore = 0
    var lowerhubAdd = 0
    var upperhubAdd = 0
    
    var autonTotal = [""]
    
//    @IBAction func submitAuton(_ sender: Any) {
//        autonTotal.append(String(didMoveOff))
//        autonTotal.append(String(lowerLabel.text!))
//        autonTotal.append(String(upperLabel.text!))
//        autonTotal.append(String(updateScore.text!))
//        global.autonArray = autonTotal
//    }
    
    
    @IBAction func movesOffTarmac(_ sender: UISwitch) {
        if sender.isOn == true {
            didMoveOff = true
            updateScore.text = String(lowerhubAdd + upperhubAdd + 2)
        }
        if sender.isOn == false {
            didMoveOff = false
            updateScore.text = String(lowerhubAdd + upperhubAdd)
        }
        global.autonData["didMoveOff"] = didMoveOff
    }
    @IBAction func clickedLowerHubStepper(_ sender: UIStepper) {
        lowerLabel.text = String(Int(sender.value))
        lowerhubAdd = Int(lowerLabel.text!)!*2
        upperhubAdd = Int(upperLabel.text!)!*4
        if didMoveOff == true {
            updateScore.text = String(lowerhubAdd + upperhubAdd + 2)
        }
        else {
            updateScore.text = String(lowerhubAdd + upperhubAdd)
        }
        global.autonData["lowerScore"] = lowerLabel.text
        global.autonData["totalScore"] = updateScore.text
    }
    
    @IBAction func clickedUpperHubStepper(_ sender: UIStepper) {
        upperLabel.text = String(Int(sender.value))
        lowerhubAdd = Int(lowerLabel.text!)!*2
        upperhubAdd = Int(upperLabel.text!)!*4
        if didMoveOff == true {
            updateScore.text = String(lowerhubAdd + upperhubAdd + 2)
        }
        else {
            updateScore.text = String(lowerhubAdd + upperhubAdd)
        }
        global.autonData["upperScore"] = upperLabel.text
        global.autonData["totalScore"] = updateScore.text
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
