//
//  MainInteractor.swift
//  BreatheApp
//
//  Created by Andrii Rogulin on 3/31/18.
//  Copyright © 2018 Andrii Rogulin. All rights reserved.
//

import Foundation

class MainInteractor: MainInteractorInterface, MainDataHandler {
    
    var dataSource: MainDataSourceInterface?
    weak var interactionOutput: MainInteractionOutput?
    
    func loadData() {
        dataSource?.loadData()
    }
    
    func onLoadedData(dataObjects: [[String : Any]]) {
        interactionOutput?.onBreathePhasesLoaded(breathePhases: dataObjects.map({ (dataObject) -> BreathePhase in
            
            let phaseType = dataObject["type"] as? String
            let durationTime = dataObject["duration"] as? Int
            let colorHexCode = dataObject["color"] as? String
            
            return BreathePhase(phaseType: phaseType, durationTime: durationTime, colorHexCode: colorHexCode)
        }))
    }
    
    func onDataLoadError(error: Error?) {
        interactionOutput?.onBreathPhasesLoadingError(error: error)
    }
    
    
}
