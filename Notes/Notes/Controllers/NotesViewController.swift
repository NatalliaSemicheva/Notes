//
//  NotesViewController.swift
//  Notes
//
//  Created by Natallia Semicheva on 7/16/19.
//  Copyright © 2019 Наталия Семичева. All rights reserved.
//

import UIKit

class NotesViewController: UITableViewController {
    private var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notes = NoteGenerator.generate()
        tableView.reloadData()
        setupNavBar()
    }
    
    private func setupNavBar() {
        title = "Заметки"
        let leftBarButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editNotes))
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func addNote() {
        openDetails(with: nil)
    }
    
    @objc func editNotes() {
        tableView.isEditing.toggle()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteCell else {
            return UITableViewCell()
        }
        let model = notes[indexPath.row]
        cell.setupCell(note: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        openDetails(with: note)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        notes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    private func openDetails(with note: Note?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "NoteDetailViewController") as? NoteDetailViewController {
            controller.delegate = self
            controller.note = note
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension NotesViewController: NoteDetailViewControllerDelegate {
    func addedNote(_ note: Note) {
        notes.append(note)
        tableView.reloadData()
    }
    
    func editedNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.uid == note.uid }) {
            notes.remove(at: index)
            notes.insert(note, at: index)
            tableView.reloadData()
        }
    }
}
