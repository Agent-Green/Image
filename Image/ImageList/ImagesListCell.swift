//
//  ImagesListCell.swift
//  Image
//
//  Created by Алиса  Грищенкова on 16.06.2024.
//

import Foundation
import UIKit

final class ImagesListCell : UITableViewCell{
    
    static let reuseIdentifier = "ImagesListCell"
        
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
    
}
