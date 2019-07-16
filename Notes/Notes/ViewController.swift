//
//  ViewController.swift
//  Notes
//
//  Created by Наталия Семичева on 6/28/19.
//  Copyright © 2019 Наталия Семичева. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
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
    
    private var selectedIndexPath = IndexPath(item: 0, section: 0)
    private var colorPicker: UIColor?
    private var isDestroyDate = false
    private let countOfColorItems = 4
    private let showDatePickerConstant: CGFloat = -10
    private let hideDatePickerConstant: CGFloat = 65
    private let scrollViewInsets: CGFloat = 180
    private var contentHeight: CGFloat {
        return textViewHeightConstraint.constant + titleTextField.frame.height
            + colorCollectionView.frame.height + destroyDateSwitch.frame.height + scrollViewInsets
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
        bindToKeyboard()
        configGesture()
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
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func actionSwitchDestroyDate(_ sender: Any) {
        isDestroyDate.toggle()
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strong = self else {
                return
            }
            strong.datePickerBottomConstraint.constant = strong.isDestroyDate ? strong.showDatePickerConstant : strong.hideDatePickerConstant
            strong.datePicker.alpha = strong.isDestroyDate ? 1 : 0
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        if indexPath.item == 3 && colorPicker == nil {
            longPress()
        }
    }
}

extension ViewController: UITextViewDelegate {
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

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}

extension ViewController: ColorPickerViewControllerDelegate {
    func chooseColor(_ color: UIColor) {
        colorPicker = color
        selectedIndexPath = IndexPath(item: 3, section: 0)
        colorCollectionView.reloadData()
    }
}
