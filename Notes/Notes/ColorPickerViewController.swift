//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by Natallia Semicheva on 7/12/19.
//  Copyright © 2019 Наталия Семичева. All rights reserved.
//

import UIKit

protocol ColorPickerViewControllerDelegate: class {
    func chooseColor(_ color: UIColor)
}

class ColorPickerViewController: UIViewController {
    @IBOutlet weak var rainbowGradientView: RainbowGradientView!
    @IBOutlet weak var pointerView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var colorNumberLabel: UILabel!
    @IBOutlet weak var pointerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pointerViewBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: ColorPickerViewControllerDelegate?
    
    var selectedColor: UIColor = .gray
    private var brightnessValue: Float = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateColor()
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        guard let recognizerView = recognizer.view else {
            return
        }
        let location = recognizer.location(in: recognizer.view)
        if location.x > 0 && location.x <= recognizerView.frame.width - 16
            && location.y > 0 && location.y <= recognizerView.frame.height - 16 {
            
            let color = rainbowGradientView.getColorAtPoint(point: location)
            
            UIView.animate(withDuration: 0.01) { [weak self] in
                guard let strong = self else {
                    return
                }
                
                strong.pointerViewLeadingConstraint.constant = location.x
                strong.pointerViewBottomConstraint.constant = -location.y
                strong.pointerView.backgroundColor = color
                strong.view.setNeedsLayout()
                strong.view.layoutIfNeeded()
                strong.selectedColor = color
                strong.updateColor()
            }
        }
    }
    
    @IBAction func actionChangeBrightness(_ sender: Any) {
        let newValue = brightnessSlider.value * Float(100)
        let changedValue: Float
        if brightnessValue > newValue {
            changedValue = -1 * (brightnessValue - newValue)
        } else {
            changedValue = newValue - brightnessValue
        }
        if let color = selectedColor.adjust(by: CGFloat(changedValue)) {
            selectedColor = color
            updateColor()
        }
        brightnessValue = newValue
    }
    
    @IBAction func actionAddColor(_ sender: Any) {
        delegate?.chooseColor(selectedColor)
        dismiss(animated: true, completion: nil)
    }
    
    private func updateColor() {
        colorView.backgroundColor = selectedColor
        colorNumberLabel.text = selectedColor.toHexString
    }
}

extension ColorPickerViewController: UIGestureRecognizerDelegate {
}
