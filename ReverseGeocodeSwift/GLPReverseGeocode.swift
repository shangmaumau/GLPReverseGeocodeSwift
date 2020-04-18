//
//  GLPReverseGeocode.swift
//  ReverseGeocodeSwift
//
//  Created by 尚雷勋 on 2020/4/13.
//  Copyright © 2020 GiANTLEAP Inc. All rights reserved.
//

import UIKit
import Contacts
import CoreLocation
import AMapSearchKit
import GoogleMaps
import MicrosoftMaps

enum GLPGeocodeService: String {
    case apple = "AppleReverseGeocode"
    case aMap = "AMapReverseGeocode"
    case baidu = "BaiduReverseGeocode"
    case google = "GoogleReverseGeocode"
    case microsoft = "MicrosoftReverseGeocode"
    case openStreet = "OpenStreetReverseGeocode"
}

class GLPGeocodeAddress: NSObject {
    var line: String?
    var coordinate: CLLocationCoordinate2D?
}

typealias GLPResultHandler = (GLPGeocodeAddress?, Error?) -> Void

class GLPReverseGeocode: NSObject, AMapSearchDelegate, BMKGeoCodeSearchDelegate {
    public var service = GLPGeocodeService.apple
    public var resultHandler: GLPResultHandler?
    
    private var amapSearchAPI: AMapSearchAPI?
    private var coordi: CLLocationCoordinate2D?
    private var coordinates: [CLLocationCoordinate2D]?
    private var addresses: [GLPGeocodeAddress]?
    
    init(service: GLPGeocodeService) {
        self.service = service
        super.init()
    }
    
    public func reverse(with coordinate: CLLocationCoordinate2D) {
        
        switch self.service {
        case .apple:
            self.appleReverse(coordinate)
        case .aMap:
            self.aMapReverse(coordinate)
        case .baidu:
            self.baiduReverse(coordinate)
        case .google:
            self.googleReverse(coordinate)
        case .microsoft:
            self.microsoftReverse(coordinate)
        case .openStreet:
            self.openStreetReverse(coordinate)
        }
    }
    
    public func reverseGeocode(with coordinate: CLLocationCoordinate2D, completionHandler: @escaping GLPResultHandler) {
        
        self.resultHandler = completionHandler
        self.coordi = coordinate
        self.reverse(with: coordinate)
        
    }
    
    // MARK:- Apple Maps reverse geocode
    
    func appleReverse(_ coordi: CLLocationCoordinate2D) {
        
        let loc = CLLocation.init(latitude: coordi.latitude, longitude: coordi.longitude)
        let coder = CLGeocoder.init()
        
        coder.reverseGeocodeLocation(loc) { (placemarks, error) in
            
            guard self.resultHandler != nil && error == nil && placemarks?.count ?? 0 > 0 else {
                return
            }
            
            var addressString = ""
            var postalAddress = ""
            let plackmark = (placemarks?.first)!
            let postalAddressFormatter = CNPostalAddressFormatter.init()
            
            if #available(iOS 11.0, *) {
                postalAddress = postalAddressFormatter.string(from: plackmark.postalAddress!)
                
            } else {
                let mPostalAddress = CNMutablePostalAddress.init()
                mPostalAddress.isoCountryCode = plackmark.isoCountryCode ?? ""
                mPostalAddress.country = plackmark.country ?? ""
                mPostalAddress.postalCode = plackmark.postalCode ?? ""
                mPostalAddress.state = plackmark.administrativeArea ?? ""
                mPostalAddress.city = plackmark.locality ?? ""
                mPostalAddress.street = plackmark.thoroughfare ?? ""
                
                if #available(iOS 10.3, *) {
                    mPostalAddress.subLocality = plackmark.subLocality ?? ""
                    mPostalAddress.subAdministrativeArea = plackmark.subAdministrativeArea ?? ""
                }
                postalAddress = postalAddressFormatter.string(from: mPostalAddress.copy() as! CNPostalAddress)
            }
            addressString = postalAddress.replacingOccurrences(of: "\n", with: "")
            
            let geoAddress = GLPGeocodeAddress.init()
            geoAddress.line = addressString.appending(plackmark.name ?? "")
            geoAddress.coordinate = plackmark.location?.coordinate
            self.resultHandler!(geoAddress, nil)
        }
    }
    
    // MARK:- AMap reverse geocode
    
    func aMapReverse(_ coordi: CLLocationCoordinate2D) {
        
        if self.amapSearchAPI == nil {
            self.amapSearchAPI = AMapSearchAPI.init()
            self.amapSearchAPI?.delegate = self
        }
        
        let regeo = AMapReGeocodeSearchRequest.init()
        regeo.location = AMapGeoPoint.location(withLatitude: CGFloat(coordi.latitude), longitude: CGFloat(coordi.longitude))
        regeo.requireExtension = true
        regeo.radius = 500
        self.amapSearchAPI?.aMapReGoecodeSearch(regeo)
    }
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        guard self.resultHandler != nil && response.regeocode != nil else {
            return
        }
        
        let geoAddress = GLPGeocodeAddress.init()
        geoAddress.line = response.regeocode.formattedAddress
        geoAddress.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(request.location.latitude), CLLocationDegrees(request.location.longitude))
        
        self.resultHandler!(geoAddress, nil)
    }
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        guard self.resultHandler != nil else {
            return
        }
        self.resultHandler!(nil, error)
    }
    
    // MARK:- Baidu Map reverse geocode
    
    func baiduReverse(_ coordi: CLLocationCoordinate2D) {
        let option = BMKReverseGeoCodeSearchOption.init()
        option.location = coordi
        option.isLatestAdmin = true
        
        let search = BMKGeoCodeSearch.init()
        search.delegate = self
        search.reverseGeoCode(option)
    }
    
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
        
        guard self.resultHandler != nil else {
            return
        }
        
        guard error == BMK_SEARCH_NO_ERROR else {
            let nerror = NSError.init(domain: NSCocoaErrorDomain, code: Int(error.rawValue), userInfo: [NSLocalizedDescriptionKey: "BMK geocode search reverse geocode error."]) as Error
            self.resultHandler!(nil, nerror)
            return
        }
        
        let geoAddress = GLPGeocodeAddress.init()
        geoAddress.line = result.address.appending(result.sematicDescription)
        geoAddress.coordinate = result.location
        self.resultHandler!(geoAddress, nil)
        
    }
    
    // MARK:- Google Maps reverse geocode
    
    func googleReverse(_ coordi: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder.init()
        geocoder.reverseGeocodeCoordinate(coordi) { (geoResponse, error) in
            
            guard self.resultHandler != nil else {
                return
            }
            guard error == nil else {
                self.resultHandler!(nil, error)
                return
            }
            
            let geoAddress = GLPGeocodeAddress.init()
            geoAddress.line = geoResponse?.firstResult()?.lines?.first
            geoAddress.coordinate = geoResponse?.firstResult()?.coordinate
            self.resultHandler!(geoAddress, nil)
        }
    }
    
    // MARK:- Microsoft Maps reverse geocode
    
    func microsoftReverse(_ coordi: CLLocationCoordinate2D) {
        
        MSMapLocationFinder.findLocations(at: MSGeopoint.init(latitude: coordi.latitude, longitude: coordi.longitude), with: nil) { (result) in
            
            guard self.resultHandler != nil else {
                return
            }
            
            guard result.status == .success else {
                let nerror = NSError.init(domain: NSCocoaErrorDomain, code: result.status.rawValue, userInfo: [NSLocalizedDescriptionKey: "Microsoft Maps reverse geocode error."]) as Error
                self.resultHandler!(nil, nerror)
                return
            }
            
            let rLocation = result.locations.first
            let geoAddress = GLPGeocodeAddress.init()
            geoAddress.line = rLocation?.displayName
            geoAddress.coordinate = CLLocationCoordinate2DMake(rLocation?.point.position.latitude ?? 0.0, rLocation?.point.position.longitude ?? 0.0)
            self.resultHandler!(geoAddress, nil)
        }
    }
    
    // MARK:- OpenStreetMap reverse geocode
    
    func openStreetReverse(_ coordi: CLLocationCoordinate2D) {
        
        let urlHead = "https://nominatim.openstreetmap.org/reverse?"
        let urlBody = String.init(format: "format=jsonv2&lat=%f&lon=%f&accept-language=en", coordi.latitude, coordi.longitude)
        let getPath = urlHead + urlBody
        let request = URLRequest.init(url: URL.init(string: getPath)!)
        
        let dataTask = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            
            guard self.resultHandler != nil else {
                return
            }
            
            guard error == nil else {
                self.resultHandler!(nil, error)
                return
            }
            
            do {
                let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as! [String: Any]
                
                if let displayName = dataDictionary["display_name"] as? String {
                    let geoAddress = GLPGeocodeAddress.init()
                    geoAddress.line = displayName
                    let backLati = (dataDictionary["lat"] as! NSString).doubleValue
                    let backLongi = (dataDictionary["lon"] as! NSString).doubleValue
                    geoAddress.coordinate = CLLocationCoordinate2DMake(backLati, backLongi)
                    self.resultHandler!(geoAddress, nil)
                }
            } catch let error as NSError {
                
                print("parsed error \(error.localizedDescription)")
            }
            
        }
        dataTask.resume()
    }
    
    
}
