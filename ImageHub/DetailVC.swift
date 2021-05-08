//
//  detailVC.swift
//  ImageHub
//
//  Created by Jiahao Lu on 5/7/21.
//

import Foundation
import UIKit

class DetailVC : UIViewController{
    
    @IBOutlet var imageView: UIImageView!
    
    var imageTitle: String? {
        willSet{
            let label = UILabel()
            label.text = newValue
            label.backgroundColor = .clear
            label.numberOfLines = 3
            label.textAlignment = .center
            label.textColor = orange
            self.navigationItem.titleView = label
        }
    }
    
    var image : UIImage?{
        willSet {
            OperationQueue.main.addOperation {
                self.imageView?.image = newValue
            }
        }
    }
}
