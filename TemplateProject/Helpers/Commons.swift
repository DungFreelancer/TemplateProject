//
//  Commons.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/1/17.
//  Copyright © 2017 HD. All rights reserved.
//

import UIKit
import CoreLocation

class Commons {
    
    static let sharedInstance: Commons = Commons()
    lazy private var locationManager: CLLocationManager = CLLocationManager()
    
    private init() {}
    
    func removePersisDomain() {
        let appDomain: String = Bundle.main.bundleIdentifier!
        USER_DEFAULT.removePersistentDomain(forName: appDomain)
    }
    
    func applicationDocumentDirectoryString() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func getLocation() -> CLLocationCoordinate2D {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        let location: CLLocation = self.locationManager.location ?? CLLocation()
        let coordinate = location.coordinate
        return coordinate
    }
    
}
