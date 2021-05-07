//
//  MainVC.swift
//  ImageHub
//
//  Created by Jiahao Lu on 5/7/21.
//

import Foundation
import UIKit

let kMaxColumns: CGFloat = 6
let kMaxPadding: CGFloat = 32

class MainVC : UIViewController{
    
    @IBOutlet weak var libraryCV: UICollectionView!
    
    var cvVertical = true
    var cvPadding: CGFloat = 8.0
    var cvColumns: CGFloat = 3
    var cvOffset: CGFloat = 0.0
    
    var library: Library!
    var items = [Item]()
    
    var searchTerm = kDefaultSearchTerm {
        didSet {
            updateImages()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateImages()
    }
    
    //MARK: - Utility
    func updateImages() {
        
        library.fetchCollection(tags: searchTerm) { result in
            switch result {
                case let .Success(collection):
                    self.items = collection.items
                case let .Failure(error):
                    print("fetch error; \(error)")
                    self.items.removeAll()
            }
            
            OperationQueue.main.addOperation {
                self.libraryCV.reloadSections(IndexSet(integer: 0))
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
            case "ShowPhotoSegue":
                if let selectedIndexPath = libraryCV.indexPathsForSelectedItems?.first,
                 let detailVC = segue.destination as? DetailVC {
                 
                 let photo = items[selectedIndexPath.row]
                 detailVC.imageTitle = photo.title
                 
                    library.getItem(thumbnail: false, item: photo) { result in
                        switch result {
                            case let .Success(imgData):
                                if let image = UIImage(data: imgData) {
                                    detailVC.image = image
                            }
                            
                            case let .Failure(error):
                                print("Error fetching image: \(error)")
                        }
                    }
                }
            
            case "SearchViewSegue":
                if let searchViewController = segue.destination as? SearchVC {
                    searchViewController.delegate = self
            }
            
            default: break
        }
    }
    
}
