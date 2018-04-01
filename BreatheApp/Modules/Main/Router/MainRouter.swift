//
//  MainRouter.swift
//  BreatheApp
//
//  Created by Andrii Rogulin on 3/31/18.
//  Copyright © 2018 Andrii Rogulin. All rights reserved.
//

import Foundation
import UIKit

class MainRouter {
    
    class func makeModule() -> UIViewController {
        let mainView = MainViewController.init(nibName: "MainViewController", bundle: Bundle.main)
        let presenter: MainPresenterInterface & MainInteractionOutput = MainPresenter()
        let interactor: MainInteractorInterface & MainDataHandler = MainInteractor()
        let dataSource: MainDataSourceInterface & LocalDataSource = MainDataSource(fileName: "breathe_phases.json")
        
        mainView.presenter = presenter
        presenter.presenterDelegate = mainView
        
        presenter.interactor = interactor
        interactor.interactionOutput = presenter
        
        interactor.dataSource = dataSource
        dataSource.dataHandler = interactor
        
        return mainView
    }
    
}
