//
//  NightView.swift
//  ARDemo
//
//  Created by Владислав Форафонтов on 28.05.2018.
//  Copyright © 2018 Владислав Форафонтов. All rights reserved.
//

import UIKit

protocol SettingsViewDelegate {
    func weatherWasChanged(on state: WeatherState)
    func dayWasChanged(on state: DayState)
}

class SettingsView: UIView {
    var myDelegate: SettingsViewDelegate?
    var isShowen = false        // показывает, выдвинут ли объект сейчас или нет
    
    @IBOutlet weak var rainSwitch: UISwitch!
    @IBOutlet weak var snowSwitch: UISwitch!
    @IBOutlet weak var fogSwitch: UISwitch!
    @IBOutlet weak var visualView: UIVisualEffectView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }

    @IBAction func dayWasChanged(_ sender: UISegmentedControl) {
        dayChanged(on: sender.selectedSegmentIndex)
    }
    
    @IBAction func rainWasChanged(_ sender: UISwitch) {
        weatherChanged(on: .rain, switchState: sender.isOn)
    }
    
    @IBAction func snowWasChanged(_ sender: UISwitch) {
        weatherChanged(on: .snow, switchState: sender.isOn)
    }
    
    @IBAction func fogWasChanged(_ sender: UISwitch) {
        weatherChanged(on: .fog, switchState: sender.isOn)
    }
    
    // функция, контроллирующая отображение visualEffect и передачу инфо через делегат
    private func dayChanged(on index: Int) {
        var effect = UIBlurEffect(style: .dark)
        var state = DayState.night
        
        if index == 0 {
            effect = UIBlurEffect(style: .light)
            state = .day
        }
        
        myDelegate?.dayWasChanged(on: state)
        UIView.animate(withDuration: 0.3) {
            self.visualView.effect = effect
        }
    }
    
    // функция, контроллирующая отображение switch's и передачу инфо через делегат
    private func weatherChanged(on state: WeatherState, switchState: Bool) {
        rainSwitch.setOn(false, animated: true)
        snowSwitch.setOn(false, animated: true)
        fogSwitch.setOn(false, animated: true)
        
        switch state {
        case .rain where switchState:
            rainSwitch.isOn = true
            myDelegate?.weatherWasChanged(on: .rain)
        
        case .snow where switchState:
            snowSwitch.isOn = true
            myDelegate?.weatherWasChanged(on: .snow)
        
        case .fog where switchState:
            fogSwitch.isOn = true
            myDelegate?.weatherWasChanged(on: .fog)
        
        default:
            myDelegate?.weatherWasChanged(on: .non)
        }
    }
    
    static var nibName = "SettingsView"
    private func loadFromNib() -> UIView {
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: SettingsView.nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return view
    }
    
    var subview: UIView!
    private func setup() {
        subview = loadFromNib()
        subview.frame = bounds
        subview.layer.mask = corners(for: subview)
        
        addSubview(subview)
    }
    
    // устанавливает закругленные углы для view
    private func corners(for view: UIView) -> CAShapeLayer {
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.bottomRight, .topRight], cornerRadii: CGSize(width: 15, height: 15)).cgPath
        
        return rectShape
    }
}
