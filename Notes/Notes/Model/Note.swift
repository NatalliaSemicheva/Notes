//
//  Note.swift
//
//
//  Created by Natallia Semicheva on 28/06/19.
//

import UIKit

enum Importance: Int, Codable {
    case minor = 0
    case average = 1
    case major
}

struct Note {
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let importance: Importance
    let selfDestructionDate: Date?
    
    init(uid: String = UUID().uuidString, title: String, content: String, color: UIColor = .white, importance: Importance, selfDestructionDate: Date? = nil) {
        self.uid = uid
        self.title = title
        self.content = content
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
        self.color = color
    }
}
