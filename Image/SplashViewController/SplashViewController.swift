//
//  SplashViewController.swift
//  Image
//
//  Created by Алиса  Грищенкова on 18.09.2024.
//

import Foundation
import UIKit
import ProgressHUD


final class SplashViewController : UIViewController{
    
    private let oAuth2Storage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service.shared
//  private let showAuthenticationSegueIdentifier = "ShowAuth"
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter: AlertPresenter?
    
    var delegate: AuthViewControllerDelegate?
    
    private let logoImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "enter_logo_image")
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        tokenCheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    private func tokenCheck() {
        if let token = oAuth2Storage.token {
            fetchProfile(token: token)
        } else {
            let vc = AuthViewController()
            vc.delegate = self
            
            alertPresenter = AlertPresenter(viewController: vc)
            
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Ок", style: .cancel) { [weak self] _ in
            guard let self else { return }
            switchToAuthViewController()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        
        present(authViewController, animated: true)
    }
    
    private func addSubviewAndMaskFalse(profileView : UIView){
        view.addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureView(){
        
        addSubviewAndMaskFalse(profileView: logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)])
    }


}


extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
                
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showAlert()
            }
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        
        UIBlockingProgressHUD.show()
        
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success:
                guard let token = oAuth2Storage.token else { return }
                fetchProfile(token: token)
            case .failure(let error):
                print("[\(String(describing: self)).\(#function)]: \(AuthServiceErrors.invalidRequest) - Ошибка получения данных профиля, \(error.localizedDescription)")
                
                let alertModel = AlertModel(
                    title: "Что-то пошло не так",
                    message: "Не удалось войти в систему",
                    buttonTitle: "ОК",
                    buttonAction: nil
                )
                alertPresenter?.show(model: alertModel)
            }
        }
    }
}



//extension SplashViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == showAuthenticationSegueIdentifier {
//            guard
//                let navigationController = segue.destination as? UINavigationController,
//                let viewController = navigationController.viewControllers[0] as? AuthViewController
//            else { fatalError("Failed to prepare for \(showAuthenticationSegueIdentifier)") }
//            viewController.delegate = self
//        } else {
//            super.prepare(for: segue, sender: sender)
//        }
//    }
//}
