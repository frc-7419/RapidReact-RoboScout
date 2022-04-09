import UIKit

class EndgameViewController: UIViewController {
    @IBOutlet weak var upperHubLabel: UILabel!
    @IBOutlet weak var updateScore: UILabel!
    @IBOutlet weak var lowerHubLabel: UILabel!
    @IBOutlet weak var initControl: UISegmentedControl!
    @IBOutlet weak var scoringBonus: UISwitch!
    @IBOutlet weak var hangarBonus: UISwitch!
    @IBOutlet weak var upperHubStepper: UIStepper!
    @IBOutlet weak var secondsPassedLabel: UILabel!
    @IBOutlet weak var lowerHubStepper: UIStepper!
    @IBOutlet weak var startTimerOutlet: UIButton!
    @IBOutlet weak var stopTimerOutlet: UIButton!
    
    @IBAction func missedPressed(_ sender: Any) {
        global.endGameData["missedShots"] = global.endGameData["missedShots"] as! Int + 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lowerHubStepper.transform = upperHubStepper.transform.scaledBy(x: 1.4, y: 1.2)
        upperHubStepper.transform = upperHubStepper.transform.scaledBy(x: 1.4, y: 1.2)
        
        scoringBonus.isOn = Bool(String(describing: global.endGameData["scoringBonus"]!)) ?? false
        hangarBonus.isOn = Bool(String(describing: global.endGameData["hangarBonus"]!)) ?? false
        // Do any additional setup after loading the view.
        updateScore.text = "0"
        initControl.selectedSegmentIndex =  Int(String(describing: global.endGameData["hangar"]!)) ?? 4
        if global.endGameData["hangar"] as! String == "low" {
            initControl.selectedSegmentIndex = 0
            hangarAdd = 4
        }
        if global.endGameData["hangar"] as! String == "mid" {
            initControl.selectedSegmentIndex = 1
            hangarAdd = 6
        }
        if global.endGameData["hangar"] as! String == "high" {
            initControl.selectedSegmentIndex = 2
            hangarAdd = 10
        }
        if global.endGameData["hangar"] as! String == "traversal" {
            initControl.selectedSegmentIndex = 3
            hangarAdd = 15
        }
        if global.endGameData["hangar"] as! String == "none" {
            initControl.selectedSegmentIndex = 4
            hangarAdd = 0
        }
        updateScore.text = String(describing: global.endGameData["totalScore"]!)
        lowerHubLabel.text = String(describing: global.endGameData["lowerScore"]!)
        upperHubLabel.text = String(describing: global.endGameData["upperScore"]!)
        lowerHubStepper.value = Double(String(describing: global.endGameData["lowerScore"]!)) ?? 0.0
        upperHubStepper.value = Double(String(describing: global.endGameData["upperScore"]!)) ?? 0.0
        secondsPassedLabel.text = String(describing: global.endGameData["timeToHang"]!)
    }
    var totalScore = 0
    var lowerhubAdd = 0
    var upperhubAdd = 0
    var hangar = "none"
    var hangarAdd = 0
    var scoringBonusSelected = false
    var hangarBonusSelected = false
    var timer = Timer()
    var secondsPassed = 0
    var didStopTimer = false
    @IBAction func hangarLevel(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
              hangar = "low"
              hangarAdd = 4
              totalScore = 4
            case 1:
              hangar = "mid"
              hangarAdd = 6
              totalScore = 6
            case 2:
              hangar = "high"
              hangarAdd = 10
              totalScore = 10
            case 3:
              hangar = "traversal"
              hangarAdd = 15
              totalScore = 15
            case 4:
              hangar = "none"
              hangarAdd = 0
              totalScore = 0
            default:
              break;
        }
        updateScore.text = String(Int(lowerHubLabel.text!)!*1 + Int(upperHubLabel.text!)!*2 + hangarAdd)
        global.endGameData["hangar"] = hangar
        global.endGameData["totalScore"] = updateScore.text!
    }
    @IBAction func scoringBonusClicked(_ sender: UISwitch) {
        if sender.isOn == true {
            scoringBonusSelected = true
        }
        else {
            scoringBonusSelected = false
        }
        global.endGameData["scoringBonus"] = scoringBonusSelected
        global.endGameData["totalScore"] = updateScore.text!
    }
    
    @IBAction func hangarBonusClicked(_ sender: UISwitch) {
        if sender.isOn == true {
            hangarBonusSelected = true
        }
        else {
            hangarBonusSelected = false
        }
        global.endGameData["hangarBonus"] = hangarBonusSelected
        global.endGameData["totalScore"] = updateScore.text!
    }
    
    @IBAction func hangerTimerStopped(_ sender: UIButton) {
        didStopTimer = true
        global.endGameData["timeToHang"] = secondsPassedLabel.text!
    }
    
    @IBAction func hangerTimer(_ sender: UIButton) {
        timer.invalidate()
        didStopTimer = false
        secondsPassed = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func goToMainPage(_ sender: UIButton) {
        let storybaord = UIStoryboard(name: "Main", bundle: nil)
        let vc = storybaord.instantiateViewController(withIdentifier: "scoutingHome")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @objc func updateTimer() {
        if (!didStopTimer) {
            secondsPassed += 1
            secondsPassedLabel.text = String(secondsPassed)
        }
    }
    
    @IBAction func upperHubStepper(_ sender: UIStepper) {
        print(hangarAdd)
        upperHubLabel.text = String(Int(sender.value))
        lowerhubAdd = Int(lowerHubLabel.text!)!
        upperhubAdd = Int(upperHubLabel.text!)!*2
        updateScore.text = String(lowerhubAdd + upperhubAdd + hangarAdd)
        global.endGameData["upperScore"] = upperHubLabel.text!
        global.endGameData["totalScore"] = updateScore.text!
    }
    
    @IBAction func lowerHubStepper(_ sender: UIStepper) {
        print(hangarAdd)
        lowerHubLabel.text = String(Int(sender.value))
        lowerhubAdd = Int(lowerHubLabel.text!)!
        upperhubAdd = Int(upperHubLabel.text!)!*2
        updateScore.text = String(lowerhubAdd + upperhubAdd + hangarAdd)
        global.endGameData["lowerScore"] = lowerHubLabel.text!
        global.endGameData["totalScore"] = updateScore.text!
    }
    
    @IBAction func goToTeleop(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "teleop")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func goToComments(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ProblemsTableView")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
    var endGameTotal = [""]
    
    @IBAction func scoringBonusDone(_ sender: Any) {
        if (sender as AnyObject).isOn == true {
            scoringBonusSelected = true
        }
    }
    
    @IBAction func hangarBonusDone(_ sender: Any) {
        if (sender as AnyObject).isOn == true {
            hangarBonusSelected = true
        }
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
