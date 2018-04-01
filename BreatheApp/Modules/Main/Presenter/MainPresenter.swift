//
//  MainPresenter.swift
//  BreatheApp
//
//  Created by Andrii Rogulin on 3/31/18.
//  Copyright © 2018 Andrii Rogulin. All rights reserved.
//

import Foundation

class MainPresenter: MainPresenterInterface, MainInteractionOutput {
    
    
    var interactor: MainInteractorInterface?
    weak var presenterDelegate: MainPresenterDelegate?
    
    private var breathePhaseViewModels: [BreathePhaseViewModel]?
    private var timer: Timer?
    
    private var totalTime = 0
    private var finishTimeForCurrentProcessingPhase = 0
    private var phaseStartTimes = [Int:Int]()
    
    func loadBreatheProgram() {
        interactor?.loadData()
    }
    
    func onBreathPhasesLoadingError(error: Error?) {
        presenterDelegate?.onProgramLoadingError(error: error)
    }
    
    func onBreathePhasesLoaded(breathePhases: [BreathePhase]) {
        breathePhaseViewModels = breathePhases.map({ (breathePhase) -> BreathePhaseViewModel in
            return BreathePhaseViewModel(breathePhase: breathePhase)
        })
        presenterDelegate?.onPrepareBreatheProgram()
    }
    
    func startBreatheProgram() {
        let time = breathePhaseViewModels?.reduce(0, { (time, viewModel) -> Int in
            return time + viewModel.durationTime
        }) ?? 0
        totalTime = time
        
        let phaseDurations = breathePhaseViewModels?.map { (viewModel) -> Int in
            return viewModel.durationTime
        } ?? []
        
        var accumulatedDuration = 0
        for (index, duration) in phaseDurations.enumerated() {
            phaseStartTimes[accumulatedDuration] = index
            accumulatedDuration += duration
        }
        startTimer()
    }
    
    func stopBreatheProgram() {
        timer?.invalidate()
        timer = nil
        phaseStartTimes.removeAll()
        breathePhaseViewModels?.removeAll()
        totalTime = 0
        finishTimeForCurrentProcessingPhase = 0
        presenterDelegate?.onFinishBreatheProgram()
    }
    
    //MARK: Private
    
    private func timeString(timeInSeconds: Int) -> String {
        let seconds: Int = timeInSeconds % 60
        let minutes: Int = (timeInSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        var curTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            self?.process(withTime: curTime)
            curTime += 1
        })
        timer?.fire()
    }
    
    private func process(withTime currentTime: Int) {
        if currentTime < self.totalTime {
            if let index = self.phaseStartTimes[currentTime], let viewModel = self.breathePhaseViewModels?[index] {
                self.finishTimeForCurrentProcessingPhase += viewModel.durationTime
                self.presenterDelegate?.onApplyPhaseName(withBreathePhaseViewModel: viewModel)
                self.presenterDelegate?.onApplyPhaseColor(withBreathePhaseViewModel: viewModel)
                self.presenterDelegate?.onApplyPhaseAnimation(withBreathePhaseViewModel: viewModel)
            }
            self.sendTimeUpdate(currentTime: currentTime)
        } else {
            stopBreatheProgram()
        }
    }
    
    private func sendTimeUpdate(currentTime: Int) {
        if currentTime < self.totalTime {
            self.presenterDelegate?.onUpdatePhaseTimer(timeString: "\(self.timeString(timeInSeconds: self.finishTimeForCurrentProcessingPhase - currentTime - 1))")
            self.presenterDelegate?.onUpdateGlobalTimer(timeString: "\(self.timeString(timeInSeconds: self.totalTime - currentTime - 1))")
        }
    }
    
}
