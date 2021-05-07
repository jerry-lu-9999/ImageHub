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

class MainVC : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
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
            
//            case "SearchViewSegue":
//                if let searchViewController = segue.destination as? SearchVC {
//                    searchViewController.delegate = self
//            }
            
            default: break
        }
    }
    
    //MARK: - CollectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        library.getItem(item: item, completion: { result in
            
            guard let index = self.items.firstIndex(of: item),
                case let .Success(imgData) = result else {
                    return
            }
            OperationQueue.main.addOperation {
                if let image = UIImage(data: imgData) {
                    let indexPath = IndexPath(item: index, section: 0)
                    if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
                        cell.update(image: image)
                    }
                }
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            UIView.animate(withDuration: 0.25, animations: {
                cell.imageView.transform = CGAffineTransform.identity.scaledBy(x: 2.0, y: 2.0)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
           UIView.animate(withDuration: 0.08) {
                cell.imageView.transform = CGAffineTransform.identity
            }
        }
    }
}

extension MainVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width
        width -= (cvColumns + 1) * cvPadding
        return CGSize(width: width/cvColumns, height: width/cvColumns)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cvPadding, left: cvPadding, bottom: cvPadding, right: cvPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cvPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cvPadding
    }
}

