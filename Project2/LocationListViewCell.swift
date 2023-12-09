//
//  LocationListViewCell.swift
//  Project2
//
//  Created by Akash Shrestha on 2023-12-08.
//

import UIKit

class LocationListViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    static let identifier = "LocationListViewCell"

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
