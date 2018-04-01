//
//  BreatheViewController.swift
//  BreatheApp
//
//  Created by Andrii Rogulin on 3/31/18.
//  Copyright © 2018 Andrii Rogulin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MainViewInterface, MainPresenterDelegate {
    
    
    @IBOutlet weak var startTitle: UILabel!
    @IBOutlet weak var squareView: UIView!
    @IBOutlet weak var phaseNameLabel: UILabel!
    @IBOutlet weak var phaseTimerLabel: UILabel!
    @IBOutlet weak var globalTimerTitleLabel: UILabel!
    @IBOutlet weak var globalTimerLabel: UILabel!
    @IBOutlet weak var squareSideConstraint: NSLayoutConstraint!
    
    var presenter: MainPresenterInterface?
    private var squareViewSideLength: Double = 0
    private var breatheProgramIsOngoing = false
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        loadInitialState(animated: false)
    }
    
    //MARK: Interface setup
    
    func setupInterface() {
        squareViewSideLength = Double(squareSideConstraint.constant)
        
        squareView.layer.shadowColor = UIColor.black.cgColor
        squareView.layer.shadowOpacity = 0.5
        squareView.layer.shadowOffset = CGSize.zero
        squareView.layer.shadowRadius = 5
        
        startTitle.text = "str_start_title".localized.uppercased()
        globalTimerTitleLabel.text = "str_remaining_title".localized.capitalized
        
        
        startTitle.textColor = UIColor.white
        globalTimerTitleLabel.textColor = UIColor.black
        phaseTimerLabel.textColor = UIColor.black
        phaseNameLabel.textColor = UIColor.black
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction))
        squareView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func loadInitialState(animated: Bool) {
        phaseNameLabel.isHidden = true
        phaseTimerLabel.isHidden = true
        globalTimerTitleLabel.isHidden = true
        globalTimerLabel.isHidden = true
        squareView.backgroundColor = UIColor.blue
        squareSideConstraint.constant = CGFloat(1 * squareViewSideLength)
        UIView.animate(withDuration: animated ? 1 : 0, animations: {
            self.squareView.layoutIfNeeded()
        }) { (completed) in
            self.startTitle.isHidden = false
            self.breatheProgramIsOngoing = false
        }
    }
    
    //MARK: User interaction
    
    @objc func tapGestureRecognizerAction() {
        if !breatheProgramIsOngoing {
            startBreathingProgram()
        }
    }
    
    //MARK: MainViewInterface
    
    func startBreathingProgram() {
        presenter?.loadBreatheProgram()
    }
    
    func stopBreathingProgram() {
        presenter?.stopBreatheProgram()
    }
    
    //MARK: MainPresenterDelegate
    
    func onProgramLoadingError(error: Error?) {
        let alertViewController = UIAlertController(title: "str_error".localized.capitalized,
                                                    message: error?.localizedDescription ?? "str_unknown_error_description".localized.capitalized,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: "str_ok".localized.uppercased(), style: .default) { (action) in
            alertViewController.dismiss(animated: true, completion: nil)
        }
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
    func onPrepareBreatheProgram() {
        breatheProgramIsOngoing = true
        startTitle.isHidden = true
        squareView.backgroundColor = UIColor.blue
        squareSideConstraint.constant = CGFloat(0.75 * squareViewSideLength)
        UIView.animate(withDuration: 1, animations: {
            self.squareView.layoutIfNeeded()
        }) { (completed) in
            self.phaseNameLabel.isHidden = false
            self.phaseTimerLabel.isHidden = false
            self.globalTimerTitleLabel.isHidden = false
            self.globalTimerLabel.isHidden = false
            self.presenter?.startBreatheProgram()
        }
    }
    
    func onApplyPhaseAnimation(withBreathePhaseViewModel viewModel: BreathePhaseViewModel) {
        if viewModel.phaseType != .unknown {
            var newSideLength: Double?
            switch viewModel.phaseType {
            case .inhale:
                newSideLength = self.squareViewSideLength * 1.0
                break
            case .exhale:
                newSideLength = self.squareViewSideLength * 0.5
                break
            default:
                break
            }
            
            let shoudPerformAnimations = newSideLength != nil
            if shoudPerformAnimations {
                self.squareSideConstraint.constant = CGFloat(newSideLength!)
                UIView.animate(withDuration: Double(viewModel.durationTime), animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    func onApplyPhaseColor(withBreathePhaseViewModel viewModel: BreathePhaseViewModel) {
        squareView.backgroundColor = viewModel.phaseColor
    }
    
    func onApplyPhaseName(withBreathePhaseViewModel viewModel: BreathePhaseViewModel) {
        phaseNameLabel.text = viewModel.phaseName
    }
    
    func onUpdatePhaseTimer(timeString: String) {
        phaseTimerLabel.text = timeString
    }
    
    func onUpdateGlobalTimer(timeString: String) {
        globalTimerLabel.text = timeString
    }
    
    func onFinishBreatheProgram() {
        loadInitialState(animated: true)
    }
    
}
