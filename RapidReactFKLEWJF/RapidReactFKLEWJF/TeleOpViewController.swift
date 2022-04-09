import UIKit

class TeleOpViewController: UIViewController {
    
    var totalScore = 0
    var lowerhubAdd = 0
    var upperhubAdd = 0

    @IBOutlet weak var updateScore: UILabel!
    @IBOutlet weak var lowerHubStepper: UIStepper!
    @IBOutlet weak var upperHubStepper: UIStepper!
    @IBOutlet weak var lowerLabel: UILabel!
    @IBOutlet weak var upperLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lowerHubStepper.transform = upperHubStepper.transform.scaledBy(x: 1.4, y: 1.2)
        upperHubStepper.transform = upperHubStepper.transform.scaledBy(x: 1.4, y: 1.2)

        // Do any additional setup after loading the view.
        updateScore.text = String(describing: global.teleOpData["totalScore"]!)
        lowerLabel.text = String(describing: global.teleOpData["lowerScore"]!)
        upperLabel.text = String(describing: global.teleOpData["upperScore"]!)
        lowerHubStepper.value = Double(String(describing: global.teleOpData["lowerScore"]!)) ?? 0.0
        upperHubStepper.value = Double(String(describing: global.teleOpData["upperScore"]!)) ?? 0.0
    }
    
    @IBAction func clickedLowerHubStepper(_ sender: UIStepper) {
        lowerLabel.text = String(Int(sender.value))
        lowerhubAdd = Int(lowerLabel.text!)!
        upperhubAdd = Int(upperLabel.text!)!*2
        updateScore.text = String(lowerhubAdd + upperhubAdd)
        global.teleOpData["lowerScore"] = lowerLabel.text!
        global.teleOpData["totalScore"] = updateScore.text!
    }
    
    @IBAction func clickedUpperHubStepper(_ sender: UIStepper) {
        upperLabel.text = String(Int(sender.value))
        lowerhubAdd = Int(lowerLabel.text!)!
        upperhubAdd = Int(upperLabel.text!)!*2
        updateScore.text = String(lowerhubAdd + upperhubAdd)
        global.teleOpData["upperScore"] = upperLabel.text!
        global.teleOpData["totalScore"] = updateScore.text!
    }
    @IBAction func goToEndgame(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "endgame")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func goToHome(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "auton")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func goToMainPage(_ sender: UIButton) {
        let storybaord = UIStoryboard(name: "Main", bundle: nil)
        let vc = storybaord.instantiateViewController(withIdentifier: "scoutingHome")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
    
    
    var teleOpTotal = [""]
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
