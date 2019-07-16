//
//  NotesTests.swift
//  NotesTests
//
//  Created by Наталия Семичева on 7/2/19.
//  Copyright © 2019 Наталия Семичева. All rights reserved.
//

import XCTest

class NotesTests: XCTestCase {
    private var note1: Note!
    private var note2: Note!
    private var fileNotebook: FileNotebook!
    
    override func setUp() {
        fileNotebook = FileNotebook()
        note1 = Note(title: "title", content: "content", importance: .average)
        note2 = Note(uid: "uid", title: "title", content: "content", color: .red, importance: .major, selfDestructionDate: Date())
    }
    
    override func tearDown() {
    }
    
    func testAddNote() {
        fileNotebook.add(note1)
        XCTAssertFalse(fileNotebook.notes.isEmpty)
    }
    
    func testDeleteCorrectNode() {
        fileNotebook.add(note1)
        fileNotebook.remove(with: note1.uid)
        XCTAssert(fileNotebook.notes.isEmpty)
    }
    
    func testDeleteWrongNote() {
        fileNotebook.add(note1)
        fileNotebook.remove(with: note2.uid)
        XCTAssertFalse(fileNotebook.notes.isEmpty)
    }
    
    func testGetNotes() {
        fileNotebook.add(note1)
        fileNotebook.saveTo(file: "file.txt")
        fileNotebook.loadFrom(file: "file.txt")
        XCTAssertFalse(fileNotebook.notes.isEmpty)
    }
    
    func testGetNotesWithWrongPath() {
        fileNotebook.add(note1)
        fileNotebook.loadFrom(file: "file23.txt")
        XCTAssert(fileNotebook.notes.isEmpty)
    }
}
