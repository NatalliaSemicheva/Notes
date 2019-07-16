//
//  ColorCell.swift
//  Notes
//
//  Created by Наталия Семичева on 7/10/19.
//  Copyright © 2019 Наталия Семичева. All rights reserved.
//

import CoreGraphics
import UIKit

class ColorCell: UICollectionViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var selectedView: SelectedView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                setupSelected()
            } else {
                setupUnselected()
            }
        }
    }
    
    func setupColor(_ color: UIColor?) {
        if let color  = color {
            colorView.backgroundColor = color
            colorView.alpha = 1
        } else {
            colorView.alpha = 0
        }
    }
    
    func setupSelected() {
        selectedView.alpha = 1
    }
    
    private func setupUnselected() {
        selectedView.alpha = 0
    }
}

class SelectedView: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setLineWidth(2)
        context.setFillColor(UIColor.black.cgColor)
        context.move(to: CGPoint(x: 5, y: 15))
        context.addLine(to: CGPoint(x: 15, y: 25))
        context.addLine(to: CGPoint(x: 25, y: 5))
        context.drawPath(using: .stroke)
    }
}
