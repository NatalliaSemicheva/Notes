//
//  NoteDetailViewController.swift
//  Notes
//
//  Created by Наталия Семичева on 6/28/19.
//  Copyright © 2019 Наталия Семичева. All rights reserved.
//

import UIKit

protocol NoteDetailViewControllerDelegate: class {
    func addedNote(_ note: Note)
    func editedNote(_ note: Note)
}

class NoteDetailViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var bottomColorConstraint: NSLayoutConstraint!
    @IBOutlet weak var destroyDateSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: NoteDetailViewControllerDelegate?
    var isAdding = true
    var note: Note?
    
    private var selectedIndexPath = IndexPath(item: 0, section: 0)
    private var colorPicker: UIColor?
    private let countOfColorItems = 4
    private let showDatePickerConstant: CGFloat = -10
    private let hideDatePickerConstant: CGFloat = 65
    private let scrollViewInsets: CGFloat = 180
    private var contentHeight: CGFloat {
        return textViewHeightConstraint.constant + titleTextField.frame.height
            + colorCollectionView.frame.height + destroyDateSwitch.frame.height + scrollViewInsets
    }
    
    private var isDestroyDate = false {
        didSet {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let strong = self else {
                    return
                }
                strong.datePickerBottomConstraint.constant = strong.isDestroyDate ? strong.showDatePickerConstant : strong.hideDatePickerConstant
                strong.datePicker.alpha = strong.isDestroyDate ? 1 : 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        colorCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentViewHeightConstraint.constant = contentHeight
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight)
    }
    
    func config() {
        setupNavBar()
        bindToKeyboard()
        configGesture()
        configNote()
    }
    
    private func setupNavBar() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addNote))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configNote() {
        if let note = note {
            titleTextField.text = note.title
            noteTextView.text = note.content
            var indexPath = IndexPath(item: 0, section: 0)
            switch note.color {
            case .white:
                indexPath.item = 0
            case .red:
                indexPath.item = 1
            case .green:
                indexPath.item = 2
            default:
                indexPath.item = 3
                colorPicker = note.color
            }
            isDestroyDate = note.selfDestructionDate != nil
            if isDestroyDate {
                datePicker.date = note.selfDestructionDate ?? Date()
            }
            selectedIndexPath = indexPath
            isAdding = false
        }
    }
    
    @objc func addNote() {
        var color = UIColor.white
        if let cell = colorCollectionView.cellForItem(at: selectedIndexPath) as? ColorCell, let backColor = cell.colorView.backgroundColor {
            color = backColor
        }
        let title: String
        if let text = titleTextField.text, !text.isEmpty {
            title = text
        } else {
            title = "Заметка"
        }
        var date: Date? = nil
        if isDestroyDate {
            date = datePicker.date
        }
        var newNote: Note
        if let note = note {
            newNote = note
            newNote.title = title
            newNote.content = noteTextView.text
            newNote.color = color
            newNote.selfDestructionDate = date
        } else {
            newNote = Note(title: title, content: noteTextView.text, color: color, selfDestructionDate: date)
        }
        isAdding ? delegate?.addedNote(newNote) : delegate?.editedNote(newNote)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func actionTap() {
        titleTextField.resignFirstResponder()
        noteTextView.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        let textViewMaxY: CGFloat = view.frame.maxY
        
        if keyboardHeight < textViewMaxY {
            bottomColorConstraint.constant = textViewMaxY - keyboardHeight
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        bottomColorConstraint.constant = 0
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    @objc func longPress() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ColorPickerViewController") as? ColorPickerViewController else {
            return
        }
        viewController.delegate = self
        viewController.selectedColor = colorPicker ?? .white
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func actionSwitchDestroyDate(_ sender: Any) {
        isDestroyDate.toggle()
    }
}

extension NoteDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countOfColorItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as? ColorCell else {
            return UICollectionViewCell()
        }
        let color: UIColor?
        switch indexPath.item {
        case 0:
            color = .white
        case 1:
            color = .red
        case 2:
            color = .green
        default:
            color = colorPicker
            
            let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
            lpgr.minimumPressDuration = 0.3
            lpgr.delaysTouchesBegan = true
            cell.addGestureRecognizer(lpgr)
        }
        cell.setupColor(color)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        if indexPath.item == 3 && colorPicker == nil {
            longPress()
        }
    }
}

extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
        textViewHeightConstraint.constant = newSize.height
        
        contentViewHeightConstraint.constant = contentHeight
    }
}

extension NoteDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}

extension NoteDetailViewController: ColorPickerViewControllerDelegate {
    func chooseColor(_ color: UIColor) {
        colorPicker = color
        colorCollectionView.reloadData()
    }
}
