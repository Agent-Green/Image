//
//  TabBarController.swift
//  Image
//
//  Created by Алиса  Грищенкова on 09.10.2024.
//

import Foundation
import UIKit
 
import UIKit


final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyBoard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil
        )
        
        viewControllers = [imagesListViewController, profileViewController]
    }
    
}
