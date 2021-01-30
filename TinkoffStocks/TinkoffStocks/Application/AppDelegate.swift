//
//  AppDelegate.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let rootController = UINavigationController(rootViewController: DefaultPresentationsFactory().makeStocksPresentation())

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()

        rootController.view.backgroundColor = UIColor.Stocks.rootControllerBackground
        return true
    }
}

