//
//  MainTapBarController.swift
//  Portfolio-App
//
//  Created by Владимир Беляев on 13.12.2020.
//

import UIKit

class MainTabBarController: UITabBarController {

    // MARK: IB Outlets
    @IBOutlet var mainTabBar: UITabBar! {
        didSet {
            mainTabBar.items?.forEach {
                $0.imageInsets = UIEdgeInsets(top: 60, left: 0, bottom: 60, right: 0)
            }
        }
    }
    
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainTabBar.roundCorners([.topLeft, .topRight], radius: 12)
    }

}
