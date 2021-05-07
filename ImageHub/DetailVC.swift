//
//  detailVC.swift
//  ImageHub
//
//  Created by Jiahao Lu on 5/7/21.
//

import Foundation
import UIKit

class DetailVC : ViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageTitle: String? {
        willSet{
            navigationItem.title = newValue
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
