//
//  PhotoCollectionViewController.swift
//  HERO
//
//  Created by Amrun on 10/10/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class PhotoCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    let identifier1 = "CellIdentifier1"
    let identifier2 = "CellIdentifier2"
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    var loggedInUserData:NSDictionary?
    
    var photos = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //get the logged in users details
            FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
            
            //store the logged in users details into the variable
            self.loggedInUserData = snapshot.value as? NSDictionary
                
            //get all the photos that are made by the user
            FIRDatabase.database().reference().child("Photos").child(FIRAuth.auth()!.currentUser!.uid).observe(.childAdded, with: { (snapshot:FIRDataSnapshot) in
                
                self.photos.append(snapshot.value as! NSDictionary)
                
                self.collectionView.insertItems(at: [IndexPath(item:1,section:0)])
              
            }){(error) in
                
                print(error.localizedDescription)
            }
            
        }
    
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView.addGestureRecognizer(lpgr)
        
        collectionView.reloadData()
        
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.began {}
        
        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        
        if let index = indexPath {
            _ = self.collectionView.cellForItem(at: index)
            // do stuff with your cell, for example print the indexPath
            
            if(index.item == 0){
            
            }else{
            //Alert
            let uiAlert = UIAlertController(title: "Delete Photo", message: "Do you want to delete this Photo?", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
                print("Click of No button")
            }))
            
            uiAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                print("Click of Yes button")
                
//                self.databaseRef.child("Photos").child(self.loggedInUser!.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
//                    if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                        for child in result {
//                            let userKey = child.key 
//                            
//                            if(userKey == "-KVnWOzArEiLq4ISmEJw"){
//                                FIRDatabase.database().reference().child("Photos").child(self.loggedInUser!.uid!).child(userKey).removeValue(completionBlock: { (error, ref) in
//                                    
//                                    if error != nil{
//                                        print("Failed to delete message", error)
//                                        
//                                        return
//                                    }
//                                    
//                                    
//                                    self.photos.remove(at: index.row)
//                                    self.collectionView.reloadData()
//                                    
//                                })
//                            }
//                        }
//                    }
//                })
            }))
            }
        } else {
            print("Could not find index path")
        }
    }

    
    func addPhotoButtonHandler(_ sender:UIButton){
        let alert = UIAlertController.init(title: "Upload Photo", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction.init(title: "Camera", style: .default) { (action) in
            self.openImagePicker(.camera)
        }
        let action2 = UIAlertAction.init(title: "Photos", style: .default) { (action) in
            self.openImagePicker(.photoLibrary)
        }
        let action3 = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func openImagePicker(_ sourceType:UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        self.navigationController?.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        //create a unique auto generated key from firebase database
        let key = FIRDatabase.database().reference().child("Photos").childByAutoId().key
        
        let storageRef = FIRStorage.storage().reference()
        let pictureStorageRef = storageRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)/photos/\(key)")
        
            let Data = UIImageJPEGRepresentation(image, 0.5)
        
        if(Data != nil){
            
            let uploadTask = pictureStorageRef.put(Data!,metadata: nil)
            {metadata,error in
                
                if(error == nil)
                {
                    let downloadUrl = metadata!.downloadURL()
                    
                    let childUpdates = [
                        "/Photos/\(FIRAuth.auth()!.currentUser!.uid)/\(key)/timestamp":"\(Date().timeIntervalSince1970)",
                        "/Photos/\(FIRAuth.auth()!.currentUser!.uid)/\(key)/photourl":downloadUrl!.absoluteString]
                    
                    FIRDatabase.database().reference().updateChildValues(childUpdates)
                }
                else
                {
                    print(error?.localizedDescription)
                }
            }
            if(Data == nil){
               print("image picker data is nil")
            }
            
            }
        
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            SVProgressHUD.dismiss()
            self.navigationController?.dismiss(animated: true, completion:nil)
        }

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
            return self.photos.count+1
            
        }else{
            
            collectionView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "nophoto"))
            collectionView.backgroundView?.contentMode = .scaleAspectFill
            return 1
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier1,for:indexPath) as! PhotoCollectionViewCell
            
            let image = UIImage(named: "storyphoto")! as UIImage
            cell.AddPhoto.setImage(image, for: .normal)
            cell.AddPhoto.addTarget(self, action: #selector(addPhotoButtonHandler), for: .touchUpInside)
            
              return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier2,for:indexPath) as! PhotoCollectionViewCell
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap))
            cell.Photo.addGestureRecognizer(tap)
            cell.Photo.isUserInteractionEnabled = true
            
            if(photos[(self.photos.count) - (indexPath.row)]["photourl"] != nil)
                        {
                            let picture = photos[(self.photos.count) - (indexPath.row)]["photourl"] as! String
                            let url = URL(string:picture)
                            cell.Photo.sd_setImage(with: url, placeholderImage: UIImage(named:"menu")!)
                        }
                        else
                        {
            //                cell.Photo.isHidden = true
                        }
              return cell
        }
        
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

//extension PhotoCollectionViewController: SJSegmentedViewControllerViewSource {
//    
//    func viewForSegmentControllerToObserveContentOffsetChange(_ controller: UIViewController,
//                                                              index: Int) -> UIView {
//        return collectionView!
//    }
//}

extension PhotoCollectionViewController: SJSegmentedViewControllerViewSource {
    
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        
        return collectionView
    }
}


extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectioViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        // http://stackoverflow.com/questions/28872001/uicollectionview-cell-spacing-based-on-device-sceen-size
        
        let length = (UIScreen.main.bounds.width-6)/3
        
        return CGSize(width: length,height: length);
    }
}

