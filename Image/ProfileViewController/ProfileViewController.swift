//
//  ProfileViewController.swift
//  Image
//
//  Created by Алиса  Грищенкова on 19.07.2024.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController{
    
    private let profileImage : UIImageView = {
        var profileImage = UIImage(named: "profilePic")
        let imageView = UIImageView(image: profileImage)
        return imageView
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhite
        return label
    }()
    
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .ypGray
        return label
    }()
    
    private let textLabel : UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .ypWhite
        return label
    }()
    
    private let exitButton : UIButton = {
        let button : UIButton = UIButton.systemButton(
            with: UIImage(named: "exitButton1") ?? UIImage(),
            target: ProfileViewController.self,
            action: #selector(Self.didTapExitButton))
        button.tintColor = .ypRed
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func addSubviewAndMaskFalse(profileView : UIView){
        view.addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureView(){
        
        addSubviewAndMaskFalse(profileView: profileImage)
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 75),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)])
        
        addSubviewAndMaskFalse(profileView: nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8)])
        
        addSubviewAndMaskFalse(profileView: descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)])
        
        addSubviewAndMaskFalse(profileView: textLabel)
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8)])
        
        addSubviewAndMaskFalse(profileView: exitButton)
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.widthAnchor.constraint(equalToConstant: 24),])
        
    }
    @objc private func didTapExitButton() {}
    
}

