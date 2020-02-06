//
//  WeatherTableViewCell.swift
//  Labb 1. Weather application
//
//  Created by Anton Gottfredsson on 2020-02-05.
//  Copyright © 2020 Anton Gottfredsson. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTemp: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
}
