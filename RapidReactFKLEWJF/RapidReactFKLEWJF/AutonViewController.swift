import UIKit

class AutonViewController: UIViewController {

    @IBOutlet weak var movesOffTarmacSwitch: UISwitch!
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var lowerLabel: UILabel!
    @IBOutlet weak var updateScore: UILabel!
    @IBOutlet weak var lowerHubStepper: UIStepper!
    @IBOutlet weak var upperHubStepper: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lowerHubStepper.transform = upperHubStepper.transform.scaledBy(x: 1.4, y: 1.2)
        upperHubStepper.transform = upperHubStepper.transform.scaledBy(x: 1.4, y: 1.2)

        // Do any additional setup after loading the view.
//        updateScore.text = "0"
//        updateScore.text = String(describing: global.autonData["totalScore"]!)
        lowerLabel.text = String(describing: global.autonData["lowerScore"]!)
        upperLabel.text = String(describing: global.autonData["upperScore"]!)
        lowerHubStepper.value = Double(String(describing: global.autonData["lowerScore"]!)) ?? 0.0
        upperHubStepper.value = Double(String(describing: global.autonData["upperScore"]!)) ?? 0.0
        movesOffTarmacSwitch.isOn = Bool(String(describing: global.autonData["didMoveOff"]!)) ?? false
        if movesOffTarmacSwitch.isOn == true {
            updateScore.text = String(Int(lowerLabel.text!)!*2 + Int(upperLabel.text!)!*4 + 2)
            global.autonData["totalScore"] = String(Int(lowerLabel.text!)!*2 + Int(upperLabel.text!)!*4 + 2)
            didMoveOff = true
        }
        if movesOffTarmacSwitch.isOn == false {
            updateScore.text = String(Int(lowerLabel.text!)!*2 + Int(upperLabel.text!)!*4)
            global.autonData["totalScore"] = String(Int(lowerLabel.text!)!*2 + Int(upperLabel.text!)!*4)
            didMoveOff = false
        }
//        else if !movesOffTarmacSwitch.isOn {
//            updateScore.text = String(describing: global.autonData["totalScore"]!)
//        }
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
        if movesOffTarmacSwitch.isOn == true {
            didMoveOff = true
            updateScore.text = String(Int(lowerLabel.text!)!*2 + Int(upperLabel.text!)!*4 + 2)
            global.autonData["totalScore"] = String(Int(lowerLabel.text!)!*2 + Int(upperLabel.text!)!*4 + 2)
        }
        if movesOffTarmacSwitch.isOn == false {
            didMoveOff = false
            updateScore.text = String(Int(lowerLabel.text!)!*2 + Int(upperLabel.text!)!*4)
            global.autonData["totalScore"] = String(Int(lowerLabel.text!)!*2 + Int(upperLabel.text!)!*4)
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
        if movesOffTarmacSwitch.isOn == true {
            global.autonData["totalScore"] = String(Int(lowerLabel.text!)!*2 + Int(upperLabel.text!)!*4 + 2)
        }
        else if movesOffTarmacSwitch.isOn == false {
            global.autonData["totalScore"] = String(Int(lowerLabel.text!)!*2 + Int(upperLabel.text!)!*4)
        }
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
        if movesOffTarmacSwitch.isOn == true {
            global.autonData["totalScore"] = String(Int(lowerLabel.text!)!*2 + Int(upperLabel.text!)!*4 + 2)
        }
        else if movesOffTarmacSwitch.isOn == false {
            global.autonData["totalScore"] = String(Int(lowerLabel.text!)!*2 + Int(upperLabel.text!)!*4)
        }
    }
    @IBAction func goToTeleop(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "teleop")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func goToHome(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "scoutingHome")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    @IBAction func goToMainPage(_ sender: UIButton) {
        let storybaord = UIStoryboard(name: "Main", bundle: nil)
        let vc = storybaord.instantiateViewController(withIdentifier: "scoutingHome")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
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
