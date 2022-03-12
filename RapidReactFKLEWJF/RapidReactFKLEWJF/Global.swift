import Foundation

let global: Global = Global()

class Global {
    var autonData: [String: Any] = [
        "didMoveOff": false,
        "lowerScore": 0,
        "upperScore": 0,
        "totalScore": 0,
        "missedShots": 0
    ]
    var teleOpData: [String: Any] = [
        "upperScore": 0,
        "lowerScore": 0,
        "totalScore": 0,
        "missedShots": 0
    ]
    var endGameData: [String: Any] = [
        "lowerScore": 0,
        "upperScore": 0,
        "hangar": "none",
        "scoringBonus": false,
        "hangarBonus": false,
        "totalScore": 0,
        "missedShots": 0
    ]
    
    var scoutingData: [String: Any] = [
        "teamNumber": 0
    ]
    
    var problemCells: [ProblemTableViewCell] = []

    func getTotalArray() -> [Any] {
        var problemsArray: [String] = []
        for problem in problemCells {
            if (problem.data["problem"] != "") {
                problemsArray.append(problem.data["problem"]!)
                problemsArray.append(problem.data["section"]!)
            }
        }
        
        let scoutingArray: [String] = [String(describing: scoutingData["teamNumber"]!)]
        let autonArray: [String] = [String(describing: autonData["didMoveOff"]!), String(describing: autonData["lowerScore"]!), String(describing: autonData["upperScore"]!), String(describing: autonData["totalScore"]!)]
        let teleOpArray: [String] = [String(describing: teleOpData["lowerScore"]!), String(describing: teleOpData["upperScore"]!), String(describing: teleOpData["totalScore"]!)]
        let endGameArray: [String] = [String(describing: endGameData["lowerScore"]!), String(describing: endGameData["upperScore"]!), String(describing: endGameData["hangar"]!), String(describing: endGameData["scoringBonus"]!), String(describing: endGameData["hangarBonus"]!), String(describing: endGameData["totalScore"]!)]
        
        let totalMissed: Int = (autonData["missedShots"] as! Int) + (teleOpData["missedShots"] as! Int) + (endGameData["missedShots"] as! Int)
        let totalMissedArray: [String] = [String(describing: totalMissed)]

        return scoutingArray + autonArray + teleOpArray + endGameArray + totalMissedArray + problemsArray;
    }
}
