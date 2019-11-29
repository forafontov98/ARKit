//
//  Constants.swift
//  ARDemo
//
//  Created by Владислав Форафонтов on 28.05.2018.
//  Copyright © 2018 Владислав Форафонтов. All rights reserved.
//

import Foundation

// перечисление состояния погоды
enum WeatherState {
    case rain
    case snow
    case fog
    case non
}

enum Weathers {
    static let rain = Weather(nameParticle: "rain.scnp", nameChildNode: "RainNode")
    static let fog = Weather(nameParticle: "fog.scnp", nameChildNode: "FogNode")
    static let snow = Weather(nameParticle: "snow.scnp", nameChildNode: "SnowNode")
}

struct Weather {
    let nameParticle: String
    let nameChildNode: String
}

// перечисление состояния день/ночь
enum DayState {
    case night
    case day
}
