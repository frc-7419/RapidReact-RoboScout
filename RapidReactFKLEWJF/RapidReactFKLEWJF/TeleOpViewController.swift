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

        // Do any additional setup after loading the view.
        updateScore.text = String(describing: global.teleOpData["totalScore"]!)
        lowerLabel.text = String(describing: global.teleOpData["lowerScore"]!)
        upperLabel.text = String(describing: global.teleOpData["upperScore"]!)
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
