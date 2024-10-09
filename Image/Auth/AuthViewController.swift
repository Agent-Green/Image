//
//  AuthViewController.swift
//  Image
//
//  Created by Алиса  Грищенкова on 04.09.2024.
//

import Foundation
import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
final class AuthViewController : UIViewController {
        
    private let authLogoImage : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "auth_screen_logo")
        return img
    }()
    
    private let loginButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        return button
    }()

    
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureBackButton()
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)

    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == ShowWebViewSegueIdentifier {
    //            guard
    //                let webViewViewController = segue.destination as? WebViewViewController
    //            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
    //            webViewViewController.delegate = self
    //        } else {
    //            super.prepare(for: segue, sender: sender)
    //        }
    //    }
    
    @objc private func didTapLoginButton() {
        let viewController = WebViewViewController()
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }

    private func addSubviewAndMaskFalse(authView : UIView){
        view.addSubview(authView)
        authView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureView(){
        
        addSubviewAndMaskFalse(authView: authLogoImage)
        NSLayoutConstraint.activate([
            authLogoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            authLogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authLogoImage.heightAnchor.constraint(equalToConstant: 60),
            authLogoImage.widthAnchor.constraint(equalToConstant: 60)])
        
        addSubviewAndMaskFalse(authView: loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: authLogoImage.bottomAnchor, constant: 204),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
//        loginButton.backgroundColor = .ypWhite
//        loginButton.layer.masksToBounds = true
//        loginButton.layer.cornerRadius = 16
//        loginButton.setTitle("Войти", for: .normal)
//        loginButton.setTitleColor(.ypBlack, for: .normal)
//        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
