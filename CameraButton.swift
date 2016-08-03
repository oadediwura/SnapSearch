//
//  CameraButton.swift
//  SnapSearch
//
//  Created by Mac on 7/26/16.
//  Copyright © 2016 Taiwo Adelabu, K.Swain & D.Nwankwo. All rights reserved.
//

import Foundation
import UIKit

class CameraButton: UIButton {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.height / 2.0
        self.clipsToBounds = true
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1.0
    }
    
}
