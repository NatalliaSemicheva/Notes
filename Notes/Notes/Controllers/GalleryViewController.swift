//
//  GalleryViewController.swift
//  Notes
//
//  Created by Natallia Semicheva on 7/16/19.
//  Copyright © 2019 Наталия Семичева. All rights reserved.
//

import Photos
import UIKit

class GalleryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let imageNames = ["first", "second", "third", "fourth", "fifth"]
    private var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        imageNames.forEach { name in
            if let image = UIImage(named: name) {
                images.append(image)
            }
        }
        collectionView.reloadData()
    }
    
    func setupNavBar() {
        title = "Галерея"
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as? GalleryCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "GalleryDetailViewController") as? GalleryDetailViewController {
            controller.images = images
            controller.selectedImageIndex = indexPath.item
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = view.frame.width - 50
        let cellBorder = viewWidth / 3
        return CGSize(width: cellBorder, height: cellBorder)
    }
    
    @objc func addImage() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                DispatchQueue.main.async { [weak self] in
                    self?.presentImagePicker()
                }
            }
        }
    }
    
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            images.append(chosenImage)
            collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}
