//
//  SceneDelegate.swift
//  ReverseGeocodeSwift
//
//  Created by 尚雷勋 on 2020/4/13.
//  Copyright © 2020 GiANTLEAP Inc. All rights reserved.
//

import UIKit
import AMapFoundationKit
import MicrosoftMaps
import GoogleMaps.GMSGeocoder

class SceneDelegate: UIResponder, UIWindowSceneDelegate, BMKGeneralDelegate {
    
    let aMapKey = "d460e10187c5503a7135111dde76e14d"
    let baiduMapKey = "VEXofsLObus9XypIQVynda5bgQt0oCz3"
    let microsoftKey = "At0ou6hfkEG2DNHij2Ym50feBPHeey3BOtq7s4yQv6mpk80OVw9sPbi8nonn6wcH"
    let googleAPIKey = ""

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        window?.rootViewController = UINavigationController.init(rootViewController: ViewController.init())
        
        /* AMap start key */
        AMapServices.shared()?.apiKey = aMapKey
        
        /* Baidu Map start key */
        let startOK = BMKMapManager.sharedInstance()?.start(baiduMapKey, generalDelegate: nil)
        if startOK == true {
            print("BMKManager start ok")
        }
        
        /* Google Maps start key */
        GMSServices.provideAPIKey(googleAPIKey)
        
        /* Microsoft Maps start key */
        MSMapView.init(frame: CGRect.zero).credentialsKey = microsoftKey
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

