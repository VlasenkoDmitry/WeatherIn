//
//  FDForecastTableViewCell.swift
//  WeatherIn
//
//  Created by Ap on 22.02.22.
//

import UIKit

class FDForecastTableViewCell: UITableViewCell {
    
    var labelDay = UILabel()
    var imageWeatherView = UIView()
    var timeforecastView = UIView()
    var timeView = UIView()
    var forecastView = UIView()
    var temperatureView = UIView()
    var weatherImage = UIImageView()
    var timeLabel = UILabel()
    var forecastLabel = UILabel()
    var temperatureLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureNameDay(row:List,indexRow:Int) {
        self.addSubview(labelDay)
        labelDay.snp.makeConstraints { maker in
            maker.left.equalTo(self).inset(16)
            maker.top.right.bottom.equalTo(self)
        }
    }
    
    func configureForecast(data: List,image:UIImage) {
        self.addSubview(imageWeatherView)
        
        imageWeatherView.snp.makeConstraints { maker in
            maker.left.equalTo(self).inset(16)
            maker.top.bottom.equalTo(self)
            maker.width.equalTo(imageWeatherView.snp.height)
        }

        self.addSubview(temperatureView)
        temperatureView.snp.makeConstraints { maker in
            maker.right.equalTo(self).inset(16)
            maker.top.bottom.equalTo(self)
            maker.width.equalTo(imageWeatherView.snp.height)
        }
        
        self.addSubview(timeforecastView)
        timeforecastView.snp.makeConstraints { maker in
            maker.left.equalTo(imageWeatherView.snp.right)
            maker.right.equalTo(temperatureView.snp.left)
            maker.top.bottom.equalTo(self)
        }
        
        timeforecastView.addSubview(timeView)
        timeforecastView.addSubview(forecastView)
        timeView.snp.makeConstraints { maker in
            maker.top.left.right.equalTo(timeforecastView)
        }
        
        forecastView.snp.makeConstraints { maker in
            maker.bottom.left.right.equalTo(timeforecastView)
            maker.top.equalTo(timeView.snp.bottom)
            maker.height.equalTo(timeView.snp.height)
        }
        
        imageWeatherView.addSubview(weatherImage)
        weatherImage.snp.makeConstraints { maker in
            maker.bottom.left.right.top.equalTo(imageWeatherView)
        }
        temperatureView.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { maker in
            maker.bottom.left.right.top.equalTo(temperatureView)
        }

        timeView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { maker in
            maker.left.equalTo(timeView).inset(20)
            maker.right.bottom.equalTo(timeView)
            maker.height.equalTo(20)
        }
        forecastView.addSubview(forecastLabel)
        forecastLabel.snp.makeConstraints { maker in
            maker.left.equalTo(forecastView).inset(20)
            maker.right.top.equalTo(forecastView)
            maker.height.equalTo(20)
        }

    }    
}