//
//  ViewController.swift
//  ReverseGeocodeSwift
//
//  Created by 尚雷勋 on 2020/4/13.
//  Copyright © 2020 GiANTLEAP Inc. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

class ViewController: UIViewController {
    
    var serviceSegment: UISegmentedControl!
    var latiTitle: UILabel!
    var latiText: UITextField!
    var longiTitle: UILabel!
    var longiText: UITextField!
    
    var addressText: UITextView!
    var reverseButton: UIButton!
    
    var geocode: GLPReverseGeocode!
    var coordi: CLLocationCoordinate2D?
    
    var hud: MBProgressHUD!
    var titlesArray:[String]!
    var titleToEnumDictionary: [String: String]!
    
    
    func fetchAvailableServices() -> [String]! {
        
        let titles = ["Apple", "AMap", "Baidu", "Google", "MS", "Open"]
        let titleToEnum = [ "Apple": GLPGeocodeService.apple.rawValue, "AMap": GLPGeocodeService.aMap.rawValue, "Baidu": GLPGeocodeService.baidu.rawValue, "Google": GLPGeocodeService.google.rawValue, "MS": GLPGeocodeService.microsoft.rawValue, "Open": GLPGeocodeService.openStreet.rawValue ]
        
        self.titlesArray = titles
        self.titleToEnumDictionary = titleToEnum
        
        return titles
    }
    
    @objc func serviceChanged(_ sender: UISegmentedControl) {
        
        self.geocode.service = GLPGeocodeService(rawValue: self.titleToEnumDictionary[self.titlesArray[sender.selectedSegmentIndex]]!) ?? GLPGeocodeService.apple
        let newCoordi = self.lastCoordi()!
        self.reverse(coordi: newCoordi)
    }
    
    func lastCoordi() -> CLLocationCoordinate2D? {
        let lati = (latiText.text! as NSString).doubleValue
        let longi = (longiText.text! as NSString).doubleValue
        return CLLocationCoordinate2DMake(lati, longi)
    }
    
    @objc func reverseAction(_ sender: UIButton) {
        let lati = (latiText.text! as NSString).doubleValue
        let longi = (longiText.text! as NSString).doubleValue
        self.reverse(coordi: CLLocationCoordinate2DMake(lati, longi))
    }
    
    @objc func tapResignFirstResponser(_ gesture: UITapGestureRecognizer) {
        if latiText.isFirstResponder {
            latiText.resignFirstResponder()
        }
        
        if longiText.isFirstResponder {
            longiText.resignFirstResponder()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Reverse Geocode"
        self.view.backgroundColor = UIColor.white;
        
        serviceSegment = UISegmentedControl.init(items: self.fetchAvailableServices())
        serviceSegment.selectedSegmentIndex = 0
        serviceSegment.addTarget(self, action: #selector(serviceChanged(_:)), for: .valueChanged)
        view.addSubview(serviceSegment)
        
        latiTitle = UILabel.init()
        latiTitle.text = "Latitude"
        latiTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
        latiTitle.textAlignment = .center
        latiTitle.layer.borderColor = UIColor.black.cgColor
        latiTitle.layer.borderWidth = 3.0
        view.addSubview(latiTitle)

        latiText = UITextField.init()
        latiText.placeholder = "Input latitude here"
        latiText.keyboardType = .decimalPad
        latiText.borderStyle = .roundedRect
        latiText.text = "32.600801"
        view.addSubview(latiText)
        
        longiTitle = UILabel.init()
        longiTitle.text = "Longitude"
        longiTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
        longiTitle.textAlignment = .center
        longiTitle.layer.borderColor = UIColor.black.cgColor
        longiTitle.layer.borderWidth = 3.0
        view.addSubview(longiTitle)

        longiText = UITextField.init()
        longiText.placeholder = "Input longitude here"
        longiText.keyboardType = .decimalPad
        longiText.borderStyle = .roundedRect
        longiText.text = "111.999553"
        view.addSubview(longiText)
        
        addressText = UITextView.init()
        addressText.isEditable = false
        addressText.font = UIFont.italicSystemFont(ofSize: 17.0)
        addressText.layer.borderColor = UIColor.black.cgColor
        addressText.layer.borderWidth = 3.0
        addressText.contentInset = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        view.addSubview(addressText)
        
        reverseButton = UIButton.init(type: .custom)
        reverseButton.setTitle("Search", for: .normal)
        reverseButton.setImage(UIImage.init(named: "search"), for: .normal)
        reverseButton.addTarget(self, action: #selector(reverseAction(_:)), for: .touchUpInside)
        view.addSubview(reverseButton)

        let padding: CGFloat = 16.0;
        let margin: CGFloat = 2.0;
        let wScale: CGFloat = UIScreen.main.bounds.width / 375.0;
        let hScale: CGFloat = UIScreen.main.bounds.height / 667.0;
        
        serviceSegment.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(padding)
            make.right.equalTo(view.snp.right).offset(-padding)
            make.top.equalTo(view.snp.top).offset(padding+kViewTopHeight)
            make.height.equalTo(30.0)
        }
        
        latiTitle.snp.makeConstraints { (make) in
            make.top.equalTo(serviceSegment.snp.bottom).offset(margin*8.0)
            make.left.equalTo(view.snp.left).offset(padding)
            make.height.equalTo(30.0*hScale)
            make.width.equalTo(100.0*wScale)
        }
        
        latiText.snp.makeConstraints { (make) in
            make.top.equalTo(serviceSegment.snp.bottom).offset(margin*8.0)
            make.left.equalTo(latiTitle.snp.right).offset(margin*4.0)
            make.right.equalTo(view.snp.right).offset(-padding)
            make.height.equalTo(30.0*hScale)
        }
        
        longiTitle.snp.makeConstraints { (make) in
            make.top.equalTo(latiTitle.snp.bottom).offset(margin*8.0)
            make.left.equalTo(view.snp.left).offset(padding)
            make.height.equalTo(30.0*hScale)
            make.width.equalTo(100.0*wScale)
        }
        
        longiText.snp.makeConstraints { (make) in
            make.top.equalTo(latiTitle.snp.bottom).offset(margin*8.0)
            make.left.equalTo(longiTitle.snp.right).offset(margin*4.0)
            make.right.equalTo(view.snp.right).offset(-padding)
            make.height.equalTo(30.0*hScale)
        }
        
        addressText.snp.makeConstraints { (make) in
            make.top.equalTo(longiTitle.snp.bottom).offset(margin*10.0)
            make.left.equalTo(view.snp.left).offset(padding)
            make.right.equalTo(view.snp.right).offset(-padding)
            make.height.equalTo(60.0*hScale)
        }
        
        reverseButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(60.0*wScale);
            make.bottom.equalTo(view.snp.bottom).offset(-padding);
            make.centerX.equalTo(view.snp.centerX)
        }

        geocode = GLPReverseGeocode.init(service: .apple)
        
        geocode.resultHandler = { [weak self] (address, error) in
            
            DispatchQueue.main.async {
                self?.hideProgressHUD()
                if error == nil {
                    self?.addressText.text = address?.line
                }
            }
        }
        
        let tapOnView = UITapGestureRecognizer.init(target: self, action: #selector(tapResignFirstResponser(_:)))
        view.addGestureRecognizer(tapOnView)
        
    }
    
    func hideProgressHUD() {
        self.hud.hide(animated: true)
    }
    
    func showProgressHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Reversing";
        self.hud = hud
    }
    
    func reverse(coordi: CLLocationCoordinate2D) {
        
        self.geocode.reverse(with: coordi)
        self.showProgressHUD()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
            self?.hideProgressHUD()
        }
    }


}

