//
//  NoteCell.swift
//  Notes
//
//  Created by Natallia Semicheva on 7/16/19.
//  Copyright © 2019 Наталия Семичева. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setupCell(note: Note) {
        colorView.backgroundColor = note.color
        titleLabel.text = note.title
        descriptionLabel.text = note.content
    }
}
