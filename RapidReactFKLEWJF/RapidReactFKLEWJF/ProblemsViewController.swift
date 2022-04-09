import Foundation
import UIKit

class ProblemTableViewCell: UITableViewCell {
    
    var data: [String: String] = [
        "problem": "",
        "section": ""
    ]
    @IBOutlet weak var problemInput: UITextField!
        
    @IBAction func problemChanged(_ sender: UITextField) {
        self.data["problem"] = sender.text!
    }
    
    func reset() {
        self.data["problem"] = ""
        self.data["section"] = ""
        problemInput.text = self.data["problem"]
    }

}

class ProblemsTableViewController: UIViewController {
    
    @IBOutlet weak var endgameOutlet: UITextField!
    @IBOutlet weak var teleopOutlet: UITextField!
    @IBOutlet weak var autonOutlet: UITextField!
    @IBAction func autonFieldChanged(_ sender: UITextField) {
        global.commentsAutonData = sender.text!
    }
    
    @IBAction func teleopFieldChanged(_ sender: UITextField) {
        global.commentsTeleopData = sender.text!
    }
    
    
    @IBAction func endgameFieldChanged(_ sender: UITextField) {
        global.commentsEndgameData = sender.text!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        autonOutlet.text = global.commentsAutonData
        teleopOutlet.text = global.commentsTeleopData
        endgameOutlet.text = global.commentsEndgameData
    }
    
    @IBAction func goToHome(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "scoutingHome")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
    @IBAction func goToEndgame(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "endgame")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func goToMainpage(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "scoutingHome")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

}
