import Foundation
import UIKit

class ProblemTableViewCell: UITableViewCell {
    
    var data: [String: String] = [
        "problem": "",
        "section": ""
    ]
    @IBOutlet weak var problemInput: UITextField!
    
    @IBOutlet weak var gameSectionButton: UIButton! {
        didSet {
            gameSectionButton.menu = addMenuItems()
            self.data["section"] = gameSectionButton.menu!.children[0].title // set inital section to first element
        }
    }
    
    func addMenuItems() -> UIMenu {
        let menuItems = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Autonomous", image: UIImage(systemName: "gamecontroller"), handler: { (_) in
                self.data["section"] = "Autonomous"
            }),
            UIAction(title: "Tele-Op", image: UIImage(systemName: "gamecontroller"), handler: { (_) in
                self.data["section"] = "Tele-Op"
            }),
            UIAction(title: "Endgame", image: UIImage(systemName: "gamecontroller"), handler: { (_) in
                self.data["section"] = "Endgame"
            })
        ])
        return menuItems
    }
        
    @IBAction func problemChanged(_ sender: UITextField) {
        self.data["problem"] = sender.text!
    }
    
    func reset() {
        self.data["problem"] = ""
        self.data["section"] = ""
        problemInput.text = self.data["problem"]
    }

}

class ProblemsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // aesthetic
        tableView.contentInset.top = 30
        // add initial row if empty

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (global.problemCells.count == 0) {
            let indexPath = IndexPath(row: 1, section: 0)
            global.problemCells.append(tableView.dequeueReusableCell(withIdentifier: "problemCell", for: indexPath) as! ProblemTableViewCell)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func addTableRow(_ sender: Any) {
        let indexPath = IndexPath(row: global.problemCells.count+1, section: 0)
        global.problemCells.append(tableView.dequeueReusableCell(withIdentifier: "problemCell", for: indexPath) as! ProblemTableViewCell)
        self.tableView.reloadData()
    }
    
    @IBAction func removeTableRow(_ sender: Any) {
        global.problemCells[global.problemCells.count-1].reset()
        global.problemCells.remove(at: global.problemCells.count-1)
        // reset data on remove
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if (indexPath.section == 0) { // problemCell
            cell =  global.problemCells[indexPath.row]
        }
        else if (indexPath.section == 1) { // addProblemCell
            cell = tableView.dequeueReusableCell(withIdentifier: "addProblemCell", for: indexPath)
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return global.problemCells.count
        }
        return 1
    }

}
