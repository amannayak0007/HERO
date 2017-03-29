//
//  SelectOrganViewController.swift
//  HERO
//
//  Created by Amrun on 08/10/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit

class SelectOrganVC: UIViewController {

    var pressed = false
//    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
//    @IBOutlet weak var button4: UIButton!
//    @IBOutlet weak var button5: UIButton!
//    @IBOutlet weak var button6: UIButton!
//    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
//    @IBOutlet weak var button9: UIButton!

    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Organ In Need"
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSForegroundColorAttributeName : UIColor.white
//        ]

        saveButton.addTarget(self, action:#selector(self.savePressed), for: .touchUpInside)
        
        self.saveButton.alpha = 0.5
        self.saveButton.isEnabled = false
        
        self.extendedLayoutIncludesOpaqueBars = true
    }


    @IBAction func back(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func Button1(_ sender: AnyObject) {
//        
//        self.saveButton.alpha = 1
//        self.saveButton.isEnabled = true
//        
//        pressed = true
//        button1.setImage(UIImage(named:"lungsS"), for:. normal)
//        Fire.shared.updateUserWithKeyAndValue("Organ", value: "Lung" as AnyObject, completionHandler: nil)
//        
//        button2.setImage(UIImage(named:"kidney"), for:. normal)
//        button3.setImage(UIImage(named:"liver"), for:. normal)
//        button4.setImage(UIImage(named:"pancreas"), for:. normal)
//        button5.setImage(UIImage(named:"Heart"), for:. normal)
//        button6.setImage(UIImage(named:"Intestine"), for:. normal)
//        button7.setImage(UIImage(named:"Eye"), for:. normal)
//        button8.setImage(UIImage(named:"bone"), for:. normal)
//        button9.setImage(UIImage(named:"veins"), for:. normal)
//    }
    
    @IBAction func Button2(_ sender: AnyObject) {
        
        self.saveButton.alpha = 1
        self.saveButton.isEnabled = true
        
        pressed = true
        button2.setImage(UIImage(named:"kidneyS"), for:. normal)
        Fire.shared.updateUserWithKeyAndValue("Organ", value: "Kidney" as AnyObject, completionHandler: nil)
        
//        button1.setImage(UIImage(named:"lungs"), for:. normal)
        button3.setImage(UIImage(named:"liver"), for:. normal)
//        button4.setImage(UIImage(named:"pancreas"), for:. normal)
//        button5.setImage(UIImage(named:"Heart"), for:. normal)
//        button6.setImage(UIImage(named:"Intestine"), for:. normal)
//        button7.setImage(UIImage(named:"Eye"), for:. normal)
        button8.setImage(UIImage(named:"bone"), for:. normal)
//        button9.setImage(UIImage(named:"veins"), for:. normal)
     }
    
    @IBAction func Button3(_ sender: AnyObject) {
        
        self.saveButton.alpha = 1
        self.saveButton.isEnabled = true
        
        pressed = true
        button3.setImage(UIImage(named:"liverS"), for:. normal)
        Fire.shared.updateUserWithKeyAndValue("Organ", value: "Liver" as AnyObject, completionHandler: nil)

//        button1.setImage(UIImage(named:"lungs"), for:. normal)
        button2.setImage(UIImage(named:"kidney"), for:. normal)
//        button4.setImage(UIImage(named:"pancreas"), for:. normal)
//        button5.setImage(UIImage(named:"Heart"), for:. normal)
//        button6.setImage(UIImage(named:"Intestine"), for:. normal)
//        button7.setImage(UIImage(named:"Eye"), for:. normal)
        button8.setImage(UIImage(named:"bone"), for:. normal)
//        button9.setImage(UIImage(named:"veins"), for:. normal)
    }

//    @IBAction func Button4(_ sender: AnyObject) {
//        
//        self.saveButton.alpha = 1
//        self.saveButton.isEnabled = true
//        
//        pressed = true
//        button4.setImage(UIImage(named:"pancreasS"), for:. normal)
//        Fire.shared.updateUserWithKeyAndValue("Organ", value: "Pancreas" as AnyObject, completionHandler: nil)
//
//        button1.setImage(UIImage(named:"lungs"), for:. normal)
//        button2.setImage(UIImage(named:"kidney"), for:. normal)
//        button3.setImage(UIImage(named:"liver"), for:. normal)
//        button5.setImage(UIImage(named:"Heart"), for:. normal)
//        button6.setImage(UIImage(named:"Intestine"), for:. normal)
//        button7.setImage(UIImage(named:"Eye"), for:. normal)
//        button8.setImage(UIImage(named:"bone"), for:. normal)
//        button9.setImage(UIImage(named:"veins"), for:. normal)
//
//    }
    
//    @IBAction func Button5(_ sender: AnyObject) {
//        
//        self.saveButton.alpha = 1
//        self.saveButton.isEnabled = true
//        
//        pressed = true
//        button5.setImage(UIImage(named:"HeartS"), for:. normal)
//        Fire.shared.updateUserWithKeyAndValue("Organ", value: "Heart" as AnyObject, completionHandler: nil)
//        
//        button1.setImage(UIImage(named:"lungs"), for:. normal)
//        button2.setImage(UIImage(named:"kidney"), for:. normal)
//        button3.setImage(UIImage(named:"liver"), for:. normal)
//        button4.setImage(UIImage(named:"pancreas"), for:. normal)
//        button6.setImage(UIImage(named:"Intestine"), for:. normal)
//        button7.setImage(UIImage(named:"Eye"), for:. normal)
//        button8.setImage(UIImage(named:"bone"), for:. normal)
//        button9.setImage(UIImage(named:"veins"), for:. normal)
//    }
    
//    @IBAction func Button6(_ sender: AnyObject) {
//        
//        self.saveButton.alpha = 1
//        self.saveButton.isEnabled = true
//        
//        button1.setImage(UIImage(named:"lungs"), for:. normal)
//        button2.setImage(UIImage(named:"kidney"), for:. normal)
//        button3.setImage(UIImage(named:"liver"), for:. normal)
//        button4.setImage(UIImage(named:"pancreas"), for:. normal)
//        button5.setImage(UIImage(named:"Heart"), for:. normal)
//        button7.setImage(UIImage(named:"Eye"), for:. normal)
//        button8.setImage(UIImage(named:"bone"), for:. normal)
//        button9.setImage(UIImage(named:"veins"), for:. normal)
//
//        pressed = true
//        button6.setImage(UIImage(named:"IntestineS"), for:. normal)
//        Fire.shared.updateUserWithKeyAndValue("Organ", value: "Intestine" as AnyObject, completionHandler: nil)
//    }
    
//    @IBAction func Button7(_ sender: AnyObject) {
//        
//        self.saveButton.alpha = 1
//        self.saveButton.isEnabled = true
//        
//        pressed = true
//        button7.setImage(UIImage(named:"EyeS"), for:. normal)
//        Fire.shared.updateUserWithKeyAndValue("Organ", value: "Eye" as AnyObject, completionHandler: nil)
//        
//        button1.setImage(UIImage(named:"lungs"), for:. normal)
//        button2.setImage(UIImage(named:"kidney"), for:. normal)
//        button3.setImage(UIImage(named:"liver"), for:. normal)
//        button4.setImage(UIImage(named:"pancreas"), for:. normal)
//        button5.setImage(UIImage(named:"Heart"), for:. normal)
//        button6.setImage(UIImage(named:"Intestine"), for:. normal)
//        button8.setImage(UIImage(named:"bone"), for:. normal)
//        button9.setImage(UIImage(named:"veins"), for:. normal)
//    }
    
    @IBAction func Button8(_ sender: AnyObject) {
        
        self.saveButton.alpha = 1
        self.saveButton.isEnabled = true
        
        pressed = true
        button8.setImage(UIImage(named:"boneS"), for:. normal)
        Fire.shared.updateUserWithKeyAndValue("Organ", value: "Bone" as AnyObject, completionHandler: nil)
        
//        button1.setImage(UIImage(named:"lungs"), for:. normal)
        button2.setImage(UIImage(named:"kidney"), for:. normal)
        button3.setImage(UIImage(named:"liver"), for:. normal)
//        button4.setImage(UIImage(named:"pancreas"), for:. normal)
//        button5.setImage(UIImage(named:"Heart"), for:. normal)
//        button6.setImage(UIImage(named:"Intestine"), for:. normal)
//        button7.setImage(UIImage(named:"Eye"), for:. normal)
//        button9.setImage(UIImage(named:"veins"), for:. normal)
    }
    
//    @IBAction func Button9(_ sender: AnyObject) {
//        
//        self.saveButton.alpha = 1
//        self.saveButton.isEnabled = true
//        
//        pressed = true
//        button9.setImage(UIImage(named:"veinsS"), for:. normal)
//        Fire.shared.updateUserWithKeyAndValue("Organ", value: "Veins" as AnyObject, completionHandler: nil)
//        
//        button1.setImage(UIImage(named:"lungs"), for:. normal)
//        button2.setImage(UIImage(named:"kidney"), for:. normal)
//        button3.setImage(UIImage(named:"liver"), for:. normal)
//        button4.setImage(UIImage(named:"pancreas"), for:. normal)
//        button5.setImage(UIImage(named:"Heart"), for:. normal)
//        button6.setImage(UIImage(named:"Intestine"), for:. normal)
//        button7.setImage(UIImage(named:"Eye"), for:. normal)
//        button8.setImage(UIImage(named:"bone"), for:. normal)
//    }

    func savePressed() {
        
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            SVProgressHUD.dismiss()
            
            if(self.button2.image(for: .normal) == #imageLiteral(resourceName: "kidneyS")){
            
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "pairedKidney1") as! pairedKidney1
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "tabbarVC") as! tabbarVC
                vc.modalPresentationStyle = .custom
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
            
//            let storyboard: UIStoryboard = UIStoryboard(name: "questions", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "question2") as! question2
//            self.navigationController?.pushViewController(vc, animated: true)
//            vc.modalPresentationStyle = .custom
//            vc.modalTransitionStyle = .crossDissolve
//            self.present(vc, animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
