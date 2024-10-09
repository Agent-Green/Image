//
//  AlertModel.swift
//  Image
//
//  Created by Алиса  Грищенкова on 09.10.2024.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonTitle: String
    let buttonAction: ((UIAlertAction) -> Void)?
}
