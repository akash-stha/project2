//
//  WeatherDetailsTableViewCell.swift
//  Project2
//
//  Created by Akash Shrestha on 2023-12-09.
//

import UIKit

class WeatherDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblDetails: UILabel!
    
    static let identifier = "WeatherDetailsTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
