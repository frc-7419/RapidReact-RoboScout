import Foundation
import UIKit

class ProblemTableViewCell: UITableViewCell {
    
    var data: [String: String] = [
        "problem": "",
        "section": ""
    ]
    
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
    

}

class ProblemsTableViewController: UITableViewController {

    var rows = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // aesthetic
        tableView.contentInset.top = 30
    }
    
    @IBAction func addTableRow(_ sender: Any) {
        rows += 1
        self.tableView.reloadData()
    }
    
    @IBAction func removeTableRow(_ sender: Any) {
        rows -= 1
        global.problemCells.remove(at: global.problemCells.count-1)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if (indexPath.section == 0) { // problemCell
            if (global.problemCells.indices.contains(indexPath.row)) {
                cell =  global.problemCells[indexPath.row]
            } else {
                let cell_i = tableView.dequeueReusableCell(withIdentifier: "problemCell", for: indexPath) as! ProblemTableViewCell
                global.problemCells.insert(cell_i, at: indexPath.row)
                cell = cell_i
            }
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
            return rows
        }
        return 1
    }

}
