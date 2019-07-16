//
//  FileNotebook.swift
//  Notes
//
//  Created by Наталия Семичева on 6/28/19.
//  Copyright © 2019 Наталия Семичева. All rights reserved.
//

import Foundation

class FileNotebook {
    private(set) var notes = [Note]()
    
    public func add(_ note: Note) {
        if let _ = notes.firstIndex(where: { model -> Bool in
            model.uid == note.uid
        }) {
            return
        }
        notes.append(note)
    }
    
    public func remove(with uid: String) {
        notes.removeAll { $0.uid == uid }
    }
    
    public func saveTo(file: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            do {
                let dictionary = notes.map { note -> [String: Any] in
                    note.json
                }
                if let text = try convertFromDictionary(dictionary) {
                    try text.write(to: fileURL, atomically: false, encoding: .utf8)
                } else {
                    print("some prodlem with conversion")
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    public func loadFrom(file: String) {
        notes.removeAll()
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            
            do {
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                guard let dict = try convertToDictionary(text: text) else {
                    print("some problems with conversion")
                    return
                }
                for value in dict {
                    if let note = Note.parse(json: value) {
                        notes.append(note)
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func convertToDictionary(text: String) throws -> [[String: Any]]? {
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
        } catch {
            return nil
        }
    }
    
    private func convertFromDictionary(_ dictionary: [[String: Any]]) throws -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return String(data: data, encoding: .utf8)
        } catch {
            throw error
        }
    }
}
