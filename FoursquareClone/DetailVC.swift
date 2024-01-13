//
//  DetailVC.swift
//  FoursquareClone
//
//  Created by hasan bilgin on 8.10.2023.
//

import UIKit
//eklendi
import MapKit
//eklendi
import ParseCore

class DetailVC: UIViewController ,MKMapViewDelegate{
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsnameLabel: UILabel!
    @IBOutlet weak var detailstypeLabel: UILabel!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        detailsMapView.delegate = self
        
        
    }
    
    func getData(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                
            }else{
                if objects != nil{
                    if objects!.count > 0 {
                        let chosenPlaceObject = objects![0]
                        
                        //OBJECTS
                        if let placeName = chosenPlaceObject.object(forKey: "name") as? String{
                            self.detailsnameLabel.text = placeName
                        }
                        
                        if let placeType = chosenPlaceObject.object(forKey: "type") as? String{
                            self.detailstypeLabel.text = placeType
                        }
                        
                        if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String{
                            self.detailsAtmosphereLabel.text = placeAtmosphere
                        }
                        
                        if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String{
                            if let placeLatitudeDouble = Double(placeLatitude){
                                self.chosenLatitude = placeLatitudeDouble
                            }
                        }
                        
                        if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String{
                            if let placeLongitudeDouble = Double(placeLongitude){
                                self.chosenLongitude = placeLongitudeDouble
                            }
                        }
                        //parse de resim veri tabanında yer alıyoyor ondna swImage klullanılmadı(yani linkten çekilmedi)
                        
                        if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject{
                            imageData.getDataInBackground { data, error in
                                if data != nil {
                                    self.detailsImageView.image = UIImage(data: data!)
                                }
                            }
                        }
                        
                        print(self.chosenLatitude)
                        print(self.chosenLongitude)
                        
                        //MAPS
                        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        let region = MKCoordinateRegion(center: location,span: span )
                        self.detailsMapView.setRegion(region, animated: true)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.detailsnameLabel.text!
                        annotation.subtitle = self.detailstypeLabel.text!
                        self.detailsMapView.addAnnotation(annotation)
                        
                        
                        
                        
                    }
                }
            }
        }
    }
    
    
    //navigasyon buton ekleme ve şekil değiştirelebilir
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //annotation varsa direk nil döndürsün
        if annotation is MKUserLocation {
            return nil
        }
        
        let reusedId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusedId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusedId)
            //sağında buton çıkarma  izin gibi
            pinView?.canShowCallout = true
            //i işareti koyar
            let button =  UIButton(type: .detailDisclosure)
            //button yerinide söledik
            pinView?.rightCalloutAccessoryView = button
        }else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    //butona tıkklankınca neolcak
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if  placemark.count > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsnameLabel.text
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions:launchOptions)
                        
                    }
                }
            }
        }
    }
    
    
}
