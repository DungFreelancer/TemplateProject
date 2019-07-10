//
//  LocationHelper.swift
//  TemplateProject
//
//  Created by Dung Do on 6/18/19.
//  Copyright © 2019 HD. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper {
    
    static let shared: LocationHelper = LocationHelper()
    
    lazy private var locationManager: CLLocationManager = CLLocationManager()
    
    private init() {}
    
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
