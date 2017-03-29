//
//  SplachScreenAnimationViewController.swift
//  SplashScreen

import UIKit
import QuartzCore



class SplachScreenAnimationViewController: UIViewController,CAAnimationDelegate {
    
    // MARK: - Variable
    var mask:CALayer?
    
    // MARK: - Outlets
    @IBOutlet var imageView:UIImageView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        
        self.mask = CALayer()
        self.mask!.contents = UIImage(named:"logoMask")!.cgImage
        self.mask!.contentsGravity = kCAGravityResizeAspect
        self.mask!.bounds = CGRect(x: 0, y: 0, width: 550, height: 550)
        self.mask!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mask!.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        
        //add logo as mask to view
        self.imageView.layer.mask = mask
        
        //bg color
        self.view.backgroundColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        
        self.animate()
        
    }
    
    // MARK: - Functions
    func animate(){
        
        //1da1f2
        
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self
        keyFrameAnimation.duration = 1.5
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 1 //Add delay 1 secund
        
        //start animation
        let initialBounds = NSValue(cgRect: self.mask!.bounds);
        
        //bounce/zooming effect
        let middleBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 550, height: 550))
        
        //final/zooming effect
        let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 1600, height: 1600))
        
        //add NSValues and keytimes
        keyFrameAnimation.values = [initialBounds,middleBounds,finalBounds];
        keyFrameAnimation.keyTimes = [0, 0.6, 1]
        
        UIView.animate(withDuration: 0.2, delay: 2.2, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.imageView.alpha = 0.0
        }, completion: nil)
        
        //animation timing funtions
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut),CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)]
        
        //add animations
        self.mask?.add(keyFrameAnimation, forKey: "bounds")
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "initialNav") as! UINavigationController
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
        
    }
    
}
