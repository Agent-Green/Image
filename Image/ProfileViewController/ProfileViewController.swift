//
//  ProfileViewController.swift
//  Image
//
//  Created by Алиса  Грищенкова on 19.07.2024.
//

import Foundation
import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController{
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let profileImage : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "Userpic")
        img.layer.cornerRadius = 35
        img.clipsToBounds = true
        return img
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
        updateAvatar()
        
        updateProfileDetails(profile: profileService.profile)
        
        setupObserver()
    }
    
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else {
            return
        }
        self.nameLabel.text = profile.name
        self.descriptionLabel.text = profile.loginName
        self.textLabel.text = profile.bio
    }
    
    private func setupObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeNotification,
                         object: nil, // nil чтобы получать уведомление от любых источников
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.profileImageURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "picStub"),
            options: [.processor(processor)]) { result in
                switch result {
                case .success(let value):
                    print(value.image)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
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
    
    @objc private func didTapExitButton() {
    }
}
