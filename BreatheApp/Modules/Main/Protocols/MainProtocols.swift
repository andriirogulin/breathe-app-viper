//
//  MainProtocols.swift
//  BreatheApp
//
//  Created by Andrii Rogulin on 3/31/18.
//  Copyright © 2018 Andrii Rogulin. All rights reserved.
//

import Foundation

//MARK: View

protocol MainViewInterface: class {
    
    var presenter: MainPresenterInterface? { get set }
    
    func startBreathingProgram()
    func stopBreathingProgram()
    
}

protocol MainPresenterDelegate: class {
    
    func onProgramLoadingError(error: Error?)
    func onPrepareBreatheProgram()
    func onApplyPhaseName(withBreathePhaseViewModel viewModel: BreathePhaseViewModel)
    func onApplyPhaseAnimation(withBreathePhaseViewModel viewModel: BreathePhaseViewModel)
    func onApplyPhaseColor(withBreathePhaseViewModel viewModel: BreathePhaseViewModel)
    func onUpdatePhaseTimer(timeString: String)
    func onUpdateGlobalTimer(timeString: String)
    func onFinishBreatheProgram()
    
}

//MARK: Presenter

protocol MainPresenterInterface: class {
    
    var interactor: MainInteractorInterface? { get set }
    weak var presenterDelegate: MainPresenterDelegate? { get set }
    
    func loadBreatheProgram()
    func startBreatheProgram()
    func stopBreatheProgram()
    
}

protocol MainInteractionOutput: class {
    
    func onBreathePhasesLoaded(breathePhases: [BreathePhase])
    func onBreathPhasesLoadingError(error: Error?)
    
}

//MARK: Interactor

protocol MainInteractorInterface: class {
    
    var dataSource: MainDataSourceInterface? { get set }
    weak var interactionOutput: MainInteractionOutput? { get set }
    
    func loadData()
    
}

protocol MainDataHandler: class {
    
    func onLoadedData(dataObjects: [[String:Any]])
    func onDataLoadError(error: Error?)
    
}


//MARK: Data Source

protocol MainDataSourceInterface: class {
    
    weak var dataHandler: MainDataHandler? { get set }
    
    func loadData()
    
}

protocol LocalDataSource: class {
    
    var fileName: String? { get set }
    
    init(fileName: String?)
    
}



