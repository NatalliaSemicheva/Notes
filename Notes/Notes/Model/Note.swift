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
    var title: String
    var content: String
    var color: UIColor
    var importance: Importance
    var selfDestructionDate: Date?
    
    init(uid: String = UUID().uuidString, title: String, content: String, color: UIColor = .white, importance: Importance = .minor, selfDestructionDate: Date? = nil) {
        self.uid = uid
        self.title = title
        self.content = content
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
        self.color = color
    }
}

class NoteGenerator {
    static func generate() -> [Note] {
        let note1 = Note(title: "Заголовок заметки", content: "Текст заметки", color: .red, importance: .minor, selfDestructionDate: Date())
        let note2 = Note(title: "Заголовок длинной заметки", content: "Очень длинный текст заметки Очень длинный текст заметки Очень длинный текст заметки Очень длинный текст заметки Очень длинный текст заметки Очень длинный текст заметки Очень длинный текст заметки Очень длинный текст заметки", color: .green, importance: .minor, selfDestructionDate: Date())
        let note3 = Note(title: "Короткая заметка", content: "Не забыть выключить утюг", color: .blue, importance: .minor, selfDestructionDate: nil)
        let note4 = Note(title: "Еще одна заметка", content: "Текст заметки", color: .black, importance: .minor, selfDestructionDate: nil)
        let note5 = Note(title: "Ну и последняя заметка", content: "Текст заметки Текст заметки Текст заметки Текст заметки Текст заметки", color: .gray, importance: .minor, selfDestructionDate: nil)
        return [note1, note2, note3, note4, note5]
    }
}
