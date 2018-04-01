//
//  BreathePhaseViewModel.swift
//  BreatheApp
//
//  Created by Andrii Rogulin on 3/31/18.
//  Copyright © 2018 Andrii Rogulin. All rights reserved.
//

import Foundation
import UIKit

enum BreathePhaseType: String {
    case inhale = "inhale"
    case exhale = "exhale"
    case hold = "hold"
    case unknown = "unknown"
}

class BreathePhaseViewModel {
    
    public var breathePhase: BreathePhase?
    
    public var phaseType: BreathePhaseType {
        guard let type = breathePhase?.phaseType else { return .unknown }
        return BreathePhaseType(rawValue: type) ?? .unknown
    }
    
    public var phaseName: String {
        return breathePhase?.phaseType?.uppercased() ?? ""
    }
    
    public var phaseColor: UIColor {
        guard let hexColorCode = breathePhase?.colorHexCode else { return UIColor.clear }
        return UIColor(hexString: hexColorCode)
    }
    
    public var durationTime: Int {
        return breathePhase?.durationTime ?? 0
    }
    
    init(breathePhase: BreathePhase?) {
        self.breathePhase = breathePhase
    }
    
}
