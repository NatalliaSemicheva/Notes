//
//  GalleryDetailViewController.swift
//  Notes
//
//  Created by Natallia Semicheva on 7/16/19.
//  Copyright © 2019 Наталия Семичева. All rights reserved.
//

import UIKit

class GalleryDetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedImageIndex = 0
    var images = [UIImage]()
    var imageViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImages()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame.size = scrollView.frame.size
            imageView.frame.origin.y = 0
            imageView.frame.origin.x = scrollView.frame.width * CGFloat(index)
        }
        let width = scrollView.frame.width * CGFloat(imageViews.count)
        scrollView.contentSize = CGSize(width: width, height: scrollView.frame.height)
        
        scrollView.scrollRectToVisible(imageViews[selectedImageIndex].frame, animated: false)
    }
    
    private func loadImages() {
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
    }
}
