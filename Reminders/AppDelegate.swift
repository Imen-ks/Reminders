//
//  AppDelegate.swift
//  Reminders
//
//  Created by Imen Ksouri on 01/06/2023.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    private let actionService = ActionService.shared

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {

        if let shortcutItem = options.shortcutItem {
            actionService.action = Action(shortcutItem: shortcutItem)
        }

        let configuration = UISceneConfiguration(
            name: connectingSceneSession.configuration.name,
            sessionRole: connectingSceneSession.role
        )
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    private let actionService = ActionService.shared

    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        actionService.action = Action(shortcutItem: shortcutItem)
        completionHandler(true)
      }
}
