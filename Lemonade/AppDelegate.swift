//
//  AppDelegate.swift
//  Lemonade
//
//  Created by Ellen Stence on 11/16/22.
//

import UIKit
import IterableSDK
import UserNotifications

@main

class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let config = IterableConfig()
        config.pushIntegrationName = "com.ebDemo.Itbl"
        config.allowedProtocols = ["http", "tel", "custom"]
        IterableAPI.initialize(apiKey: Tokens.apiKey, launchOptions: launchOptions, config: config)
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus != .authorized {
                // not authorized, ask for permission
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, _ in
                    if success {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                    // TODO: Handle error etc.
                }
            } else {
                // already authorized
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication,
                didRegisterForRemoteNotificationsWithDeviceToken
                    deviceToken: Data) {
        IterableAPI.register(token: deviceToken)
    }

    func application(_ application: UIApplication,
                didFailToRegisterForRemoteNotificationsWithError
                    error: Error) {
        print("Failed to register token: \(error.localizedDescription)")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .list, .sound])
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        IterableAppIntegration.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
    }
}

func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    IterableAppIntegration.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
}

