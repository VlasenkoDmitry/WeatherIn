import Foundation
import UIKit
import SnapKit

class TodayVC: UIViewController {
    private var statusBarView = UIView()
    private var navigationBarView = UIView()
    private var pageContentView = UIView()
    private var cityView = UIView()
    private var parametersAndDescriptionView = UIView()
    private var parametersView = UIView()
    private var descriptionView = UIView()
    private var parametersFirstLineView = UIView()
    private var parametersSecondLineView = UIView()
    private var humidityView = UIView()
    private var precipitationView = UIView()
    private var pressureView = UIView()
    private var speedWindView = UIView()
    private var degWindView = UIView()
    private var descriptionLabel = UILabel()
    var presenter = PresenterTodayVC()
    private weak var viewInputputDelegate: ViewInputDelegateFirstVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewOutputDelegate(viewOutputDelegate: self)
        self.viewInputputDelegate = presenter
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillStaticDataParameters()
        formatTextLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawLines()
        presenter.takeDataFirstVC()
    }
    
    private func initialize() {
        setLayout()
        addRecognizer(label: descriptionLabel)
    }
    
    private func setLayout() {
        self.view.backgroundColor = .white
        view.setLayoutStatusBar(bar: statusBarView)
        view.setLayoutNavigationBar(navigationBar: navigationBarView, statusBar: statusBarView)
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.top.equalTo(statusBarView.snp.bottom)
            maker.left.right.equalToSuperview().inset(0)
        }
        view.addSubview(pageContentView)
        pageContentView.snp.makeConstraints { maker in
            maker.top.equalTo(navigationBarView.snp.bottom)
            maker.left.right.equalToSuperview().inset(0)
            maker.bottom.equalToSuperview().inset(100)
        }
        
        insertTwoEqualViewsVertically(firstView: cityView, secondView: parametersAndDescriptionView, mainView: pageContentView)
        insertTwoEqualViewsVertically(firstView: parametersView, secondView: descriptionView, mainView: parametersAndDescriptionView)
        insertTwoEqualViewsVertically(firstView: parametersFirstLineView, secondView: parametersSecondLineView, mainView: parametersView)
        insertEqualViewsHorizontally(views: [humidityView, precipitationView, pressureView], mainView: parametersFirstLineView)
        insertEqualViewsHorizontally(views: [speedWindView, degWindView], mainView: parametersSecondLineView)
        
        /// For the practice of the Builder we create viewParameters not by creating a separate inheritor UIView class.
        let builder = BuilderViewParameterWeather()
        let director = DirectorViewParameterWeather(builder: builder)
        builder.reset(view: humidityView)
        humidityView = director.changeView()
        builder.reset(view: precipitationView)
        precipitationView = director.changeView()
        builder.reset(view: pressureView)
        pressureView = director.changeView()
        builder.reset(view: speedWindView)
        speedWindView = director.changeView()
        builder.reset(view: degWindView)
        degWindView = director.changeView()
        
        descriptionView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { maker in
            maker.top.left.right.bottom.equalTo(descriptionView)
        }
        
        setLayoutCityView()
    }
    
    private func insertTwoEqualViewsVertically(firstView: UIView, secondView: UIView, mainView: UIView) {
        mainView.addSubview(firstView)
        mainView.addSubview(secondView)
        firstView.snp.makeConstraints { maker in
            maker.top.equalTo(mainView.snp.top)
            maker.left.right.equalTo(mainView).inset(0)
            maker.height.equalTo(secondView)
        }
        secondView.snp.makeConstraints { maker in
            maker.bottom.equalTo(mainView.snp.bottom)
            maker.left.right.equalTo(mainView)
            maker.top.equalTo(firstView.snp.bottom)
            maker.height.equalTo(firstView)
        }
    }
    
    private func insertEqualViewsHorizontally(views: [UIView], mainView: UIView) {
        for (index, view) in views.enumerated() {
            if index == 0 {
                mainView.addSubview(view)
                view.snp.makeConstraints { maker in
                    maker.top.bottom.left.equalTo(mainView)
                }
            } else if index != views.count - 1 {
                mainView.addSubview(view)
                view.snp.makeConstraints { maker in
                    maker.top.bottom.equalTo(mainView)
                    maker.left.equalTo(views[index - 1].snp.right)
                    maker.width.equalTo(views[index - 1])
                }
            } else {
                mainView.addSubview(view)
                view.snp.makeConstraints { maker in
                    maker.top.bottom.right.equalTo(mainView)
                    maker.left.equalTo(views[index - 1].snp.right)
                    maker.width.equalTo(views[index - 1])
                }
            }
        }
    }
    
    private func setLayoutCityView() {
        let imageView = UIImageView()
        cityView.addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.top.equalTo(cityView.snp.top).inset(100)
            maker.center.equalTo(cityView)
            maker.width.equalTo(imageView.snp.height)
        }
        let locationLabel = UILabel()
        cityView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { maker in
            maker.top.equalTo(imageView.snp.bottom).inset(-10)
            maker.left.right.equalTo(view)
            maker.height.equalTo(30)
        }
        locationLabel.tag = 1
        let dataWeatherLabel = UILabel()
        cityView.addSubview(dataWeatherLabel)
        dataWeatherLabel.snp.makeConstraints { maker in
            maker.top.equalTo(locationLabel.snp.bottom).inset(-10)
            maker.left.right.equalTo(view)
            maker.height.equalTo(30)
        }
        dataWeatherLabel.tag = 2
    }
    
    private func fillStaticDataParameters() {
        navigationBarView.getAllSubViewsOf(type: UILabel.self)[0].text = "Today".localize()
        descriptionLabel.text = "Description".localize()
        setImageToView(view: humidityView, image: UIImage(named: "humidity"))
        setImageToView(view: pressureView, image: UIImage(named: "pressure"))
        setImageToView(view: speedWindView, image: UIImage(named: "speedWind"))
        setImageToView(view: degWindView, image: UIImage(named: "degWind"))
        setImageToView(view: precipitationView, image: UIImage(named: "precipitation"))
    }
    
    private func setImageToView(view: UIView, image: UIImage?, color: UIColor = .black) {
        let imageView = view.getAllSubViewsOf(type: UIImageView.self)[0]
        imageView.image = image
        if color != .black {
            imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
        }
    }
    
    private func updateTodayVC(weatherToday: WeatherToday, imageWeatherToday: UIImage?) {
        updateCityViewLabels(weatherToday: weatherToday)
        updateParametersViewLabels(weatherToday: weatherToday)
        setImageToView(view: cityView, image: imageWeatherToday, color: .yellow)
    }
    
    private func updateCityViewLabels(weatherToday: WeatherToday) {
        let labelsCityView = cityView.getAllSubViewsOf(type: UILabel.self)
        for label in labelsCityView {
            switch label.tag {
            case 1:
                //locationLabel
                guard let city = weatherToday.name else { return }
                guard let country = weatherToday.sys.country else { return }
                let location = city + ", " + country
                label.text = location
            case 2:
                //dataWeatherLabel
                guard let temperature = weatherToday.main.temp else { return }
                guard let description = weatherToday.weather[0].description else { return }
                label.text = String(Int(temperature)) + "°" + " | " + description.formatFirstUppercased()
            default:
                label.text = ""
            }
        }
    }
    
    private func updateParametersViewLabels(weatherToday: WeatherToday) {
        if let humidity = weatherToday.main.humidity {
            humidityView.setTextToLabel(text: String(Int(humidity)), measure: " %")
        }
        var precipitation = "0"
        if let snow = weatherToday.snow?["1h"] {
            precipitation = String(snow)
        }
        if let rain = weatherToday.rain?["1h"] {
            precipitation = String(rain)
        }
        precipitationView.setTextToLabel(text: precipitation, measure: " mm".localize())
        if let pressure = weatherToday.main.pressure {
            pressureView.setTextToLabel(text: String(Int(pressure)), measure: " hPa".localize())
        }
        if let windSpeed = weatherToday.wind.speed {
            speedWindView.setTextToLabel(text: String(Int(windSpeed)), measure: " km/h".localize())
        }
        if let windDirection = weatherToday.wind.deg?.direction {
            degWindView.setTextToLabel(text: windDirection.description.localize(), measure: nil)
        }
    }
        
    private func formatTextLabels() {
        let labelNavigationBar = navigationBarView.getAllSubViewsOf(type: UILabel.self)[0]
        labelNavigationBar.format(size: 17)
        let labelsCityView = cityView.getAllSubViewsOf(type: UILabel.self)
        for label in labelsCityView {
            switch label.tag {
            case 1:
                //locationLabel
                label.format(size: 17)
            case 2:
                //dataWeatherLabel
                guard let blueColor =  UIColor(named: "MyBlue") else { return }
                label.format(size: 34, weight: .light, textColor: blueColor)
            default:
                label.format(size: 17)
            }
        }
        let labelsParametersView = parametersView.getAllSubViewsOf(type: UILabel.self)
        for label in labelsParametersView {
            label.format(size: 15)
        }
        descriptionLabel.format(size: 17, weight: .regular, textColor: .orange)
    }
    
    private func drawLines() {
        navigationBarView.drawLineDifferentColor(colorArray: [.systemPink, .orange, .green, .blue, .yellow, .red],lineWidth: 2, lineLength: 4, lineSpacing:  2, corners: .bottom)
        let imageViews = parametersView.getAllSubViewsOf(type: UIImageView.self)
        for imageView in imageViews {
            imageView.drawDashLine(strokeColor: .gray, lineLength: 4, lineSpacing:  2, distanceBorder: 3, corners: .all)
        }
        parametersView.drawDashLine(strokeColor: .gray, lineLength: 4, lineSpacing: 1, corners: .bottom, trimLine: self.view.frame.size.width / 3)
        parametersView.drawDashLine(strokeColor: .gray, lineLength: 4, lineSpacing: 1, corners: .top, trimLine: self.view.frame.size.width / 3)
    }
    
    private func addRecognizer(label: UILabel) {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        descriptionView.addGestureRecognizer(recognizer)
    }
    
    @objc private func tapDetected() {
        showAlert(title: "Ok".localize(), text: "Good weather...".localize())
    }
}

extension TodayVC: ViewOutputDelegateTodayVC {
    func publishDataTodayVC(weatherToday: WeatherToday?, imageWeatherToday: UIImage?) {
        guard let dataCurrent = weatherToday else { return }
        updateTodayVC(weatherToday: dataCurrent, imageWeatherToday: imageWeatherToday)
    }
}
