//
//  AddPlaceModel.swift
//  FoursquareClone
//
//  Created by hasan bilgin on 10.10.2023.
//

import Foundation
import UIKit

//Singleton sınıfı oluşturma amaç bir ekrandan diğer ekrana data taşımak

class AddPlaceModel{
    static let sharedInstance = AddPlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init() {}
    
}
