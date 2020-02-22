//
//  CoreLocationSession.swift
//  MapKitLab
//
//  Created by Melinda Diaz on 2/21/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation
import CoreLocation
import NetworkHelper

class CoreLocationSession: NSObject {
    //TODO: WHY?? and fix StartMonitoringRegion()
    public var locationManager: CLLocationManager
    override init() {
        locationManager = CLLocationManager()
           //the super.init() needs to be above the delegate but below the locationManager instance WHY???
           super.init()
           locationManager.delegate = self
           
           //request the user location
           locationManager.requestAlwaysAuthorization()
           locationManager.requestWhenInUseAuthorization()
        //The following keys need to be added to the info p.list file from your console(or at least that is what your console ask of you)///Notes!!
        startSignificantChanges()
         // startMonitoringRegion()
}
    
    private func startSignificantChanges() {
          //if it is not available !
          if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
          return
          }
          //less aggressive than the startUpdatingLocation() in GPS monitoring changes
          locationManager.startMonitoringSignificantLocationChanges()
      }
    
    public func convertCoordinateToPlacemark(coordinate: CLLocationCoordinate2D) {
           //we will use the CLGeocoder() class for converting coordinate (CLLocationCoordinate2D) to placemark (CLPlacemark) we can grab anything we want and ther eis alot of information about the place
           //CLGeocoder() calls apple's location API
           //we need to creat a CLLocatiohn
           let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
           CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
               //there are better location maps with more information and data. Like GoogleMaps and other 3RD party like mapbox etc
               if let error = error {
                   print("reverseGeocodingLocation \(error)")
               }
               if let firstPlacemark = placemarks?.first {
                   print("placemark info \(firstPlacemark)")
               }
           }
    }
    //MARK: Make it conform model
//        private func startMonitoringRegion() {
//             let identifier = "monitoring region"
//            let location = APIClient.getSchools { (result) in
//                switch result {
//                case .failure(let appError):
//                    break
//                case .success(let nearbySchools):
//                    DispatchQueue.main.async {
//                        //self.locationManager.stopMonitoring(for: CLRegion)
//                    }
//            }
//                let region = CLCircularRegion(center: NYSchools, radius: 500, identifier: identifier)
//            //it will update the region when it enters or leaves the radius, the default is value is usually true
//            region.notifyOnEntry = true
//            region.notifyOnExit = false
//            //our location manager now listens to the changes and now the function in the extension didEnterRegion, if you do not call this you will get an error
//            locationManager.startMonitoring(for: region)
//        }
//}
    public func convertPlaceNameToCoordinate(addressString: String) {
          //converting an address to coordinate
          CLGeocoder().geocodeAddressString("") { (placemarks, error) in
              if let error = error {
                  print("goecodeAddressString: \(error)")
              }
              if let firstPlaceName = placemarks?.first,
                  let location = firstPlaceName.location {
                  print("coordinate\(location.coordinate)")
              }
          }
      }
}

extension CoreLocationSession: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //its gives back an array because there are multiple locations it receives. You want the last of that array. So it will be //locations.last That method gets called when the user changes location.
          print("didUpdatelocations \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
          print("Did fail with \(error)")
}
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          //what is the current access to the user services, do you have access or not?
          switch status {
          case .authorizedAlways:
              print("authorizedAlways - always has access")
          case .authorizedWhenInUse:
              print("authorizationWhen In use - only has info when the app is in use")
          case .denied:
              // document says The user denied the use of location services for the app or they are disabled globally in Settings.
              print("denied - user denied access")
          case .notDetermined:
              print("not determined - has not prompted the user yet")
          case .restricted:
              print("restricted - The app is not access there is not enough info on it")
              //document says The app is not authorized to use location services look at https://developer.apple.com/documentation/corelocation/clauthorizationstatus
          //we need a default case cause apple might make more cases
          default:
              break
          }
      }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
          //we use that to see if we entered regions like a circle it has a center and a radius
          print("Did enter Region \(region)")
      }
    
      func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
          print("Did Exit Region \(region)")
      }
}
