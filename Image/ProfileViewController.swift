//
//  ProfileViewController.swift
//  Image
//
//  Created by Алиса  Грищенкова on 19.07.2024.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController{
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let profileImage = UIImage(named: "profilePic")
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 75),
            imageView.widthAnchor.constraint(equalToConstant: 75),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)])
        
        let nameLabel = UILabel()
        view.addSubview(nameLabel)
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        nameLabel.textColor = .ypWhite
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.widthAnchor.constraint(equalToConstant: 235),
            nameLabel.heightAnchor.constraint(equalToConstant: 18)])
        
        let nicLabel = UILabel()
        view.addSubview(nicLabel)
        nicLabel.text = "@ekaterina_nov"
        nicLabel.font = UIFont.systemFont(ofSize: 13)
        nicLabel.textColor = .ypGray
        nicLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nicLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nicLabel.widthAnchor.constraint(equalToConstant: 99),
            nicLabel.heightAnchor.constraint(equalToConstant: 18)])
        
        let textLabel = UILabel()
        view.addSubview(textLabel)
        textLabel.text = "Hello, world!"
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textColor = .ypWhite
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textLabel.topAnchor.constraint(equalTo: nicLabel.bottomAnchor, constant: 8),
            textLabel.heightAnchor.constraint(equalToConstant: 18),
            textLabel.widthAnchor.constraint(equalToConstant: 77)])
        
        let exitButton = UIButton.systemButton(
            with: UIImage(named: "exitButton1")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        exitButton.tintColor = .ypRed
        
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.widthAnchor.constraint(equalToConstant: 24),])
    }
    @objc private func didTapButton() {}
    
}


