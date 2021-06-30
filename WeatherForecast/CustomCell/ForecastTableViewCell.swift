//
//  ForecastTableViewCell.swift
//  WeatherForecast
//
//  Created by Adebayo Adesokan on 30.06.2021.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var maximumLabel: UILabel!
    
    @IBOutlet weak var minimumLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
