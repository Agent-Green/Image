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
    
    @IBOutlet var enterButton: UIButton!
    
    private let authLogoImage : UIImageView = {
        var image = UIImage(named: "auth_screen_logo")
        var imageView = UIImageView(image: image)
        return imageView
    }()
    
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureBackButton()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
        
        addSubviewAndMaskFalse(authView: enterButton)
        NSLayoutConstraint.activate([
            enterButton.topAnchor.constraint(equalTo: authLogoImage.bottomAnchor, constant: 204),
            enterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            enterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            enterButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        enterButton.backgroundColor = .ypWhite
        enterButton.layer.masksToBounds = true
        enterButton.layer.cornerRadius = 16
        enterButton.setTitle("Войти", for: .normal)
        enterButton.setTitleColor(.ypBlack, for: .normal)
        enterButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
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
        dismiss(animated: true)
    }
}
