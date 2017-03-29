
//  ViewController.swift


import UIKit
import MapKit
import CoreLocation
import Firebase

class MatchesViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pulseImage: UIImageView!
    @IBOutlet weak var Searchlabel: UILabel!
    
    let pulsator = Pulsator()
    let locationManager = CLLocationManager()
    var users = [User]()
    var loggedInUserData:NSDictionary?

/*
    var annotations: [JPSThumbnailAnnotation] {
        
//        var thumbnails: [Any] = [["image": "ottawa.jpg", "title": "Parliament of Canada", "subtitle": "Oh Canada!", "coordinate": NSValue(mkCoordinate: CLLocationCoordinate2DMake(45.43, -75.70))]]
//        (thumbnails as NSArray).enumerateObjects({(_ thumbnailDict: [String : Any], _ idx: Int, _ stop: Bool) -> Void in
//            var thumbnail = JPSThumbnail()
//            thumbnail.image = UIImage(named: thumbnailDict["image"])
//            thumbnail.title = thumbnailDict["title"]
//            thumbnail.subtitle = thumbnailDict["subtitle"]
//            thumbnail.coordinate = thumbnailDict["coordinate"].mkCoordinate
//            thumbnail.disclosureBlock = {
//                self.thumbnailDisclosureTapped(idx)
//            }
//            mapView.addAnnotation(JPSThumbnailAnnotation(thumbnail: empire))
//        })
        
        // User1
        let empire = JPSThumbnail()
        empire.image = #imageLiteral(resourceName: "img2")
        empire.title = "Louise W Jones"
        empire.subtitle = "Miami beach, FL"
        empire.coordinate = CLLocationCoordinate2DMake(25.790654, -80.1300455)
        empire.disclosureBlock = { print("selected Empire") }
        
//        let address = "miami beach, florida"
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
//            if((error) != nil){
//                print("Error", error)
//            }
//            if let placemark = placemarks?.first {
//                empire.coordinate = placemark.location!.coordinate
//            }
//        })
    
        
        // User2
        let apple = JPSThumbnail()
        apple.image = #imageLiteral(resourceName: "img1")
        apple.title = "John Garneau"
        apple.subtitle = "Palm Beach Gardens"
        apple.coordinate = CLLocationCoordinate2DMake(26.80108893932576, -80.1263701915741)
        apple.disclosureBlock = { print("selected Apple") }
        
//        let address1 = "miami beach collins park, florida"
//        let geocoder1 = CLGeocoder()
//        geocoder1.geocodeAddressString(address1, completionHandler: {(placemarks, error) -> Void in
//            if((error) != nil){
//                print("Error", error)
//            }
//            if let placemark = placemarks?.first {
//                apple.coordinate = placemark.location!.coordinate
//            }
//        })
        
        // User3
        let ottawa = JPSThumbnail()
        ottawa.image = #imageLiteral(resourceName: "img4")
        ottawa.title = "William Routh"
        ottawa.subtitle = "Collins Park, FL"
        ottawa.coordinate = CLLocationCoordinate2DMake(25.802837256788948, -80.13160586357117)
        ottawa.disclosureBlock = { print("selected Ottawa") }
//        
//        let address2 = "miami beach golf club, florida"
//        let geocoder2 = CLGeocoder()
//        geocoder2.geocodeAddressString(address2, completionHandler: {(placemarks, error) -> Void in
//            if((error) != nil){
//                print("Error", error)
//            }
//            if let placemark = placemarks?.first {
//                ottawa.coordinate = placemark.location!.coordinate
//            }
//        })
        
        // User4
        let Miami = JPSThumbnail()
        Miami.image = #imageLiteral(resourceName: "img3")
        Miami.title = "Adriana Flanagan"
        Miami.subtitle = "South beach, Miami"
        ottawa.coordinate = CLLocationCoordinate2DMake(25.79741835466293, -80.12745380401611)
        Miami.disclosureBlock = { print("selected Ottawa") }
       
//        let address3 = "south beach, miami"
//        let geocoder3 = CLGeocoder()
//        geocoder3.geocodeAddressString(address3, completionHandler: {(placemarks, error) -> Void in
//            if((error) != nil){
//                print("Error", error)
//            }
//            if let placemark = placemarks?.first {
//                Miami.coordinate = placemark.location!.coordinate
//            }
//        })

        
        return [empire, apple, ottawa, Miami].map {
            JPSThumbnailAnnotation(thumbnail: $0)
        }
    }

*/
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        mapView.delegate = self
        // Annotations
//        mapView.addAnnotations(annotations)
        
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
             self.loggedInUserData = snapshot.value as? NSDictionary
                
             print("\(self.loggedInUserData?["displayName"] as! String)")
                
            }, withCancel: nil)

        
        fetchUser()
        Pulse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setNavigationBarItem()
//        Pulse()
    }

    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        (view as? JPSThumbnailAnnotationViewProtocol)?.didSelectAnnotationView(inMap: mapView)
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        (view as? JPSThumbnailAnnotationViewProtocol)?.didDeselectAnnotationView(inMap: mapView)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return (annotation as? JPSThumbnailAnnotationProtocol)?.annotationView(inMap: mapView)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error: " + error.localizedDescription)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pulseImage.layer.layoutIfNeeded()
        pulsator.position = pulseImage.layer.position
    }
    
    func Pulse(){
    
        let blackOverlay = UIView(frame: mapView.frame)
        blackOverlay.layer.backgroundColor = UIColor.black.cgColor
        blackOverlay.layer.opacity = 0.8
        self.view!.addSubview(blackOverlay)
        self.view.addSubview(pulseImage)
        
        pulseImage.layer.superlayer?.insertSublayer(pulsator, below: pulseImage.layer)
        pulsator.start()
        pulsator.backgroundColor = UIColor(red: CGFloat(1.00), green: CGFloat(0.00), blue: CGFloat(0.20), alpha: CGFloat(1.00)).cgColor
        pulsator.animationDuration = Double(3.00)
        pulsator.radius = CGFloat(140)
        pulsator.numPulse = Int(4)
        self.pulseImage.isHidden = false
       
        Searchlabel.isHidden = false
        self.view!.addSubview(Searchlabel)

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
        self.pulsator.stop()
        self.pulseImage.isHidden = true
        blackOverlay.removeFromSuperview()
        self.Searchlabel.isHidden = true
            
        }
    }

    @IBAction func currentLocation(_ sender: Any) {
    
        self.locationManager.startUpdatingLocation()
    }
    
    func fetchUser() {
        
        //gets users from Firebase
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key //gets ID from the user
                
                //if you use this setter, your app will crash if your class properties don't exavtly match up with the Firebase dictionary keys
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
//                print("\(dictionary["displayName"] as! String)")
                
                // Calculate DOB
                let birthday = user.DOB
                let dateFormater = DateFormatter()
                dateFormater.dateStyle = .medium
                dateFormater.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
                let birthdayDate = dateFormater.date(from: birthday!)
                let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
                let now: NSDate! = NSDate()
                let calcAge = calendar.components(.year, from: birthdayDate!, to: now as Date, options: [])
                let age = calcAge.year
                
                let thumbnail = JPSThumbnail()
                thumbnail.image = #imageLiteral(resourceName: "herologo")
                thumbnail.imgUrl = user.image
                thumbnail.title = "\(user.displayName!), \(age!)"
                thumbnail.subtitle = "\(user.City!), \(user.State!)"
                thumbnail.coordinate = CLLocationCoordinate2DMake((user.latitude as AnyObject).doubleValue as! CLLocationDegrees, (user.longitude as AnyObject).doubleValue as! CLLocationDegrees)
                thumbnail.disclosureBlock = {
                
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SearchRootViewController") as! SearchRootViewController
                    vc.user = user
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                self.mapView.addAnnotation(JPSThumbnailAnnotation(thumbnail: thumbnail))
            
            }
            
            }, withCancel: nil)
    }

}

