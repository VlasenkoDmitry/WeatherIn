import UIKit

class FDForecastTableViewCell: UITableViewCell {
    
    private lazy var labelDay = UILabel()
    private lazy var imageWeatherView = UIView()
    private lazy var timeforecastView = UIView()
    private lazy var timeView = UIView()
    private lazy var forecastView = UIView()
    private lazy var temperatureView = UIView()
    private lazy var weatherImage = UIImageView()
    private lazy var timeLabel = UILabel()
    private lazy var forecastLabel = UILabel()
    private lazy var temperatureLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureNameDayCell(row: List, indexRow: Int) {
        layoutNameDay()
        fillingNameDay(row: row, indexRow: indexRow)
        formatTextNameDay()
    }
    
    private func layoutNameDay() {
        self.addSubview(labelDay)
        labelDay.snp.makeConstraints { maker in
            maker.left.equalTo(self).inset(16)
            maker.top.right.bottom.equalTo(self)
        }
    }
    
    private func fillingNameDay(row: List, indexRow: Int) {
        var text = ""
        guard let date = row.dt else { return }
        if indexRow == 0 {
            text = "TODAY".localize()
        } else {
            let timeData = NSDate(timeIntervalSince1970: TimeInterval(date))
            text = timeData.dayOfWeek()
        }
        labelDay.text = text
    }
    
    private func formatTextNameDay() {
        labelDay.format(size: 17, textAlignment: .left)
    }
    
    func configureForecastCell(data: List, image: UIImage?) {
        layoutForecast()
        fillingForecast(data: data, image: image)
        formatTextForecast()
    }
    
    private func layoutForecast() {
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
    
    private func fillingForecast(data: List, image: UIImage?) {
        if let image = image {
            weatherImage.image = image
        }
        guard let blueColor =  UIColor(named: "MyBlue") else { return }
        temperatureLabel.format(size: 34, textColor: blueColor)
        guard let temp = data.main.temp else { return  }
        temperatureLabel.text = String(Int(temp)) + " C°"
        guard let day = data.dt else { return }
        guard let description = data.weather[0].description else { return }
        let timeData = NSDate(timeIntervalSince1970: TimeInterval(day))
        timeLabel.text = timeData.date()
        forecastLabel.text = description.firstUppercased()
    }
    
    private func formatTextForecast() {
        timeLabel.format(size: 17, textAlignment: .left)
        forecastLabel.format(size: 15, textAlignment: .left)
    }
}
