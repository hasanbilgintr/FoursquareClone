//
//  MapVC.swift
//  FoursquareClone
//
//  Created by hasan bilgin on 8.10.2023.
//

import UIKit
//eklendi ve @IBOutlet weak var mapView: MKMapView! için eklendi yoksa hata alırız
import MapKit
//eklendi
import ParseCore

class MapVC: UIViewController ,MKMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        
        //manuel back butonu eklendi
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        //en iyi konum alması için kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //requestWhenInUseAuthorization sadece kullandığım zaman göstermesi yeterli
        locationManager.requestWhenInUseAuthorization()
        //her zaaman konumu güncellemesini başlatıcak
        locationManager.startUpdatingLocation()
        //plistten yetkide verildi
        
        
        
        //harita tıklanma özelliği..
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
        

    }
    
    @objc func chooseLocation(gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = AddPlaceModel.sharedInstance.placeName
            annotation.subtitle = AddPlaceModel.sharedInstance.placeType
            
            self.mapView.addAnnotation(annotation)
            
            AddPlaceModel.sharedInstance.placeLatitude = String(coordinates.latitude)
            AddPlaceModel.sharedInstance.placeLongitude  = String(coordinates.longitude)
        }
    }
    
    //kullanıcının yeri Update olunca neolcak function
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //bu kod satırı çalıştırıldıktan sonra bidaha locationUpdate yapamayacak diyebilirixz
        //locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        //haritanın width ve height belirtir zoomlu olarak
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //navigatinobarda çıkmadı ondna doalyısıyla ekran bi önceki ekranınan NavigationController eklendi hatta hepsinin önüneden eklenebilir ama back çıkmadı manuel ekledik onuda yukarda
    @objc func saveButtonClicked(){
        //save
        
        let object = PFObject(className: "Places")
        object["name"] = AddPlaceModel.sharedInstance.placeName
        object["type"] = AddPlaceModel.sharedInstance.placeType
        object["atmosphere"] = AddPlaceModel.sharedInstance.placeAtmosphere
        object["latitude"] = AddPlaceModel.sharedInstance.placeLatitude
        object["longitude"] = AddPlaceModel.sharedInstance.placeLongitude
        
        if let imageData = AddPlaceModel.sharedInstance.placeImage.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        object.saveInBackground { succes, error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            }else {
                
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
    }
    
    @objc func backButtonClicked(){
        //bu navigationController da yapılırsa zaten önceki navigationController oldupğu iççin işimize yaramıycak
        //navigationController?.popViewController(animated: true)
        //bu olan navigationControlleri bitirip en son açılan ekrana getirir diyebiliriz
        self.dismiss(animated: true)
    }
    
    func makeAlert(titleInput : String , messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    


}
