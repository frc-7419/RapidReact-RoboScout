import GoogleAPIClientForREST_Sheets
import GoogleSignIn
import UIKit
import Combine
import GTMSessionFetcherCore
import AuthenticationServices

class ScoutingViewController: UIViewController, UITextFieldDelegate {
    
    private let service = GTLRSheetsService()
    private var signedInSubscription: AnyCancellable?
    //scrollView.keyboardDismissMode = .Interactive

    @IBOutlet weak var output: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var teamNumberTextField: UITextField!
    @IBOutlet weak var TeleopOutlet: UIButton!
    @IBOutlet weak var AutonOutlet: UIButton!
    @IBOutlet weak var ProblemsOutlet: UIButton!
    @IBOutlet weak var EndgameOutlet: UIButton!
    @IBOutlet weak var ResetOutlet: UIButton!
    
    @IBAction func teamNumberChanged(_ sender: Any) {
        global.scoutingData["teamNumber"] = teamNumberTextField.text!
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.teamNumberTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        teamNumberTextField.text = String(describing: global.scoutingData["teamNumber"]!) ?? ""
        
        signedInSubscription = UIApplication.appDelegate
                    .$signedInUser
                    .receive(on: DispatchQueue.main)
                    .sink { [unowned self] user in
            if user != nil {
                signInButton.isEnabled = false
                submitButton.isEnabled = true
                logoutButton.isEnabled = true
                TeleopOutlet.isEnabled = true
                AutonOutlet.isEnabled = true
                EndgameOutlet.isEnabled = true
                ProblemsOutlet.isEnabled = true
                ResetOutlet.isEnabled = true
                output.text =
                """
                Signed in!
                User granted scopes: \(user?.grantedScopes?.joined(separator: "\n") ?? "none")
                """
                // Enable later API calls to be authorized.
                // The below will add the correct headers to the outgoing request
                service.authorizer = user?.authentication.fetcherAuthorizer()
            } else {
                output.text = "Not signed in."
                signInButton.isEnabled = true
                submitButton.isEnabled = false
                logoutButton.isEnabled = false
                TeleopOutlet.isEnabled = false
                AutonOutlet.isEnabled = false
                EndgameOutlet.isEnabled = false
                ProblemsOutlet.isEnabled = false
                ResetOutlet.isEnabled = false
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return teamNumberTextField.resignFirstResponder()
    }
    
    @IBAction func signInWithGoogle(_ sender: Any) {
        Task {
            try? await UIApplication.appDelegate.signInOrRestore(presenting: self)
            // signedInSubscription will handle changing UI
        }
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        Task {
            // Before we call the API it is best practice to ensure the needed scope is granted.
            // As of now, we cannot ask the user for a scope as part of the initial sign-in.
            if !(UIApplication.appDelegate.signedInUser?.hasSheetsScope ?? false) {
                _ = try? await GIDSignIn.sharedInstance.addScopes(scopes: [kGTLRAuthScopeSheetsSpreadsheets], presenting: self)
            }
            // Scopes have been granted...or the user cancelled at which point the below will fail
            
            output.text = "Appending data..."
            let spreadsheetId = "1_3wMHPrS2Wv_cfSmCq53yKdpecHgc8tyy71nwGv4jnk"
            let range = "A1:AA"
            let rangeToAppend = GTLRSheets_ValueRange.init();
            rangeToAppend.values = [global.getTotalArray()]
            let query = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: rangeToAppend, spreadsheetId: spreadsheetId, range: range)
            query.valueInputOption = "USER_ENTERED"
            
            service.executeQuery(query) { (ticket, result, error) in
                
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.output.text = "Success! Teri Ma!"
                }
            }
        }
        
    }
    
    @IBAction func onReset(_ sender: UIButton) {
        global.scoutingData["teamNumber"] = ""
        teamNumberTextField.text = ""
        global.teleOpData["totalScore"] = 0
        global.teleOpData["lowerScore"] = 0
        global.teleOpData["upperScore"] = 0
        global.teleOpData["missedShots"] = 0
        global.autonData["didMoveOff"] = false
        global.autonData["lowerScore"] = 0
        global.autonData["upperScore"] = 0
        global.autonData["totalScore"] = 0
        global.autonData["missedShots"] = 0
        global.endGameData["lowerScore"] = 0
        global.endGameData["upperScore"] = 0
        global.endGameData["totalScore"] = 0
        global.endGameData["hangar"] = "none"
        global.endGameData["scoringBonus"] = false
        global.endGameData["hangarBonus"] = false
        global.endGameData["missedShots"] = 0
        global.commentsAutonData = ""
        global.commentsTeleopData = ""
        global.commentsEndgameData = ""
    }
    
    
    @IBAction func onLogoutPress(_ sender: Any) {
        UIApplication.appDelegate.signOut()
    }
    
    @IBAction func goToAuton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "auton")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func goToTeleop(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "teleop")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func goToEndgame(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "endgame")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func goToComments(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ProblemsTableView")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
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
