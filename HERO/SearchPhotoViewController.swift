//
//  SearchPhotoViewController.swift
//  HERO
//
//  Created by Amrun on 01/11/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class SearchPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User?
    var databaseRef = FIRDatabase.database().reference()
    
    var photos = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
    
        if(user?.uid != nil){
    
            //get all the Photos that are made by the user
            
            self.databaseRef.child("Photos").child(self.user!.uid!).observe(.childAdded, with: { (snapshot:FIRDataSnapshot) in
                
                self.photos.append(snapshot.value as! NSDictionary)
                
                self.collectionView.insertItems(at: [IndexPath(item:0,section:0)])
                
            }){(error) in
                
                print(error.localizedDescription)
            }
        }
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if photos.count > 0 {
            
            collectionView.backgroundView = UIImageView(image: nil)
            return self.photos.count
            
        }else{
            
            collectionView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "nophoto"))
            collectionView.backgroundView?.contentMode = .scaleAspectFill
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier2", for:indexPath) as! PhotoCollectionViewCell
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap))
            cell.Photo.addGestureRecognizer(tap)
            cell.Photo.isUserInteractionEnabled = true
            
            if(photos[(self.photos.count-1) - (indexPath.row)]["photourl"] != nil)
            {
                let picture = photos[(self.photos.count-1) - (indexPath.row)]["photourl"] as! String
                let url = URL(string:picture)
                cell.Photo.sd_setImage(with: url, placeholderImage: UIImage(named:"menu")!)
            }
            else
            {
                //                cell.Photo.isHidden = true
            }
            return cell
    }
    
    func tap(_ sender:UITapGestureRecognizer) {
        
        let imageView = sender.view as! UIImageView
        let imageInfo   = GSImageInfo(image: imageView.image!, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: sender.view!)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        present(imageViewer, animated: true, completion: nil)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent //or default
    }
}

//extension SearchPhotoViewController: SJSegmentedViewControllerViewSource {
//    
//    func viewForSegmentControllerToObserveContentOffsetChange(_ controller: UIViewController,
//                                                              index: Int) -> UIView {
//        return collectionView!
//    }
//}

extension SearchPhotoViewController: SJSegmentedViewControllerViewSource {
    
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        
        return collectionView
    }
}

extension SearchPhotoViewController: UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectioViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        // http://stackoverflow.com/questions/28872001/uicollectionview-cell-spacing-based-on-device-sceen-size
        
        let length = (UIScreen.main.bounds.width-6)/3
        
        return CGSize(width: length,height: length);
    }
}

