//
//  Extensions.swift
//  ARDemo
//
//  Created by Владислав Форафонтов on 28.05.2018.
//  Copyright © 2018 Владислав Форафонтов. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

// MARK: - SettingsViewDelegate
extension ViewController: SettingsViewDelegate {
    func weatherWasChanged(on state: WeatherState) {
        switch state {
        case .fog: create(particle: Weathers.fog)
        case .rain: create(particle: Weathers.rain)
        case .snow: create(particle: Weathers.snow)
        default: create(particle: nil)
        }
    }
    
    func dayWasChanged(on state: DayState) {
        // TODO: - day and night will change THIS
    }
}
