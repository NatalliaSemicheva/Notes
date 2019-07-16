//
//  Note.swift
//
//
//  Created by Natallia Semicheva on 28/06/19.
//

import UIKit

extension Note: Codable {
    
    enum NoteCodingKeys: CodingKey {
        case uid
        case title
        case content
        case color
        case importance
        case selfDestructionDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NoteCodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        
        if let colorArray = try? container.decode([CGFloat].self, forKey: .color) {
            color = UIColor(red: colorArray[0], green: colorArray[1], blue: colorArray[2], alpha: colorArray[3])
        } else {
            color = .white
        }
        
        if let imp = try? container.decode(Importance.self, forKey: .importance) {
            importance = imp
        } else {
            importance = .average
        }
        
        if let timeInterval = try? container.decode(Double.self, forKey: .selfDestructionDate) {
            selfDestructionDate = Date(timeIntervalSince1970: timeInterval)
        } else {
            selfDestructionDate = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NoteCodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        
        if color != .white {
            let colorArray = color.cgColor.components
            try container.encode(colorArray, forKey: .color)
        }
        if importance != .average {
            try container.encode(importance, forKey: .importance)
        }
        if let date = selfDestructionDate {
            let dateInt = Double(date.timeIntervalSince1970)
            try container.encode(dateInt, forKey: .selfDestructionDate)
        }
    }
    
    var json: [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
            return json ?? [String: Any]()
        } catch {
            return [String: Any]()
        }
    }
    
    static func parse(json: [String: Any]) -> Note? {
        do {
            let decoder = JSONDecoder()
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let note = try decoder.decode(Note.self, from: data)
            return note
        } catch {
            return nil
        }
    }
}
