import Foundation

let global: Global = Global()

class Global {
    var autonData: [String: Any] = [
        "didMoveOff": false,
        "lowerScore": 0,
        "upperScore": 0,
    ]
    var teleOpData: [String: Any] = [
        "upperScore": 0,
        "lowerScore": 0
    ]
    var endGameData: [String: Any] = [
        "lowerScore": 0,
        "upperScore": 0,
        "hangar": "none",
        "scoringBonus": false,
        "hangarBonus": false
    ]
    
    var scoutingData: [String: Any] = [
        "teamNumber": 0
    ]
    
    var problemCells: [ProblemTableViewCell] = []

    func getTotalArray() -> [Any] {
        var problemsArray: [String] = []
        for problem in problemCells {
            problemsArray.append(problem.data["problem"]!)
            problemsArray.append(problem.data["section"]!)
        }
        
        let scoutingArray: [String] = [String(describing: scoutingData["teamNumber"]!)]
        let autonArray: [String] = [String(describing: autonData["didMoveOff"]!), String(describing: autonData["lowerScore"]!), String(describing: autonData["upperScore"]!)]
        let teleOpArray: [String] = [String(describing: teleOpData["upperScore"]!), String(describing: teleOpData["lowerScore"]!)]
        let endGameArray: [String] = [String(describing: endGameData["lowerScore"]!), String(describing: endGameData["upperScore"]!), String(describing: endGameData["hangar"]!), String(describing: endGameData["scoringBonus"]!), String(describing: endGameData["hangarBonus"]!)]

        return scoutingArray + autonArray + teleOpArray + endGameArray + problemsArray;
    }
}
