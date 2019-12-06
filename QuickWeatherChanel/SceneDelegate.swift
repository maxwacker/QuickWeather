//Created by Maxime Wacker on 05/12/2019.
//Copyright © 2019 Max. All rights reserved.

import UIKit
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let sceneCycle = OSLog(subsystem: subsystem, category: "SceneCycle")
    static let splitViewCycle = OSLog(subsystem: subsystem, category: "SplitViewCycle")
}

class CityRouter: CityRouting {
    func requestCityNextdaysScreen(for cityName: String) {
        
    }
    
}


class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    let router: CityRouting = CityRouter()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        os_log("Scene Delegate will Connect", log: OSLog.sceneCycle, type: .info)
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: UIScreen.main.bounds)

        let cityInteractor = CityInteractor(cityNetService: CityNetworkService())
        // Instantiate root view controllers
        let citiesTableViewController = CitiesTableViewController(interactor: cityInteractor)
        let cityDetailViewController = CityNextDaysViewController()
        
        
        // Embed in navigation controllers
        let masterNavigationViewController = UINavigationController(rootViewController: citiesTableViewController)
        let detailNavigationController = UINavigationController(rootViewController: cityDetailViewController)
        
        
        // Embed in Split View controller
        let splitViewController = UISplitViewController()
        splitViewController.viewControllers = [masterNavigationViewController, detailNavigationController]
        splitViewController.preferredPrimaryColumnWidthFraction = 1/3
        splitViewController.preferredDisplayMode = .allVisible
        
        splitViewController.delegate = self

        // Root view controller of window
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
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

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        os_log("SplitView Collapsing decision", log: OSLog.splitViewCycle, type: .info)

        // From Apple Master-Detail template
//        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
//        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
//        if topAsDetailController.detailItem == nil {
//            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//            return true
//        }
//        return false
        return true
    }

}

