//
//  PhotoCell.swift
//  ImageHub
//
//  Created by Jiahao Lu on 5/7/21.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        update(image: nil)
    }
    
    
    override var isSelected: Bool{
        didSet {
            if isSelected {
                layer.borderWidth = 4
                layer.borderColor = UIColor.white.cgColor
            } else {
                layer.borderWidth = 0.5
                layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    func update(image: UIImage?){
        layer.borderWidth = 0.5
        layer.cornerRadius = 6
        layer.borderColor = UIColor.black.cgColor

        if let displayImage = image {
            activityIndicator.stopAnimating()
            imageView.image = displayImage
        } else {
            activityIndicator.startAnimating()
            imageView.image = nil
        }
    }
}
