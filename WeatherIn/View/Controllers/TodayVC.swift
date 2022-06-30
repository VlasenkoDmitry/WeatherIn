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
    var presenter = PresenterFirstVC()
    private weak var viewInputputDelegate: ViewInputDelegateFirstVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        fillingStaticDataParameters()
        formatAllText()
        addRecognizer(label: descriptionLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.setViewOutputDelegate(viewOutputDelegate: self)
        self.viewInputputDelegate = presenter
        presenter.takeDataFirstVC()
        drawLine()
    }
    
    private func layout() {
        self.view.backgroundColor = .white
        view.layoutStatusBar(bar: statusBarView)
        view.layoutNavigationBar(navigationBar: navigationBarView, statusBar: statusBarView)
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
        
        insertingTwoEqualViewsVertically(firstView: cityView, secondView: parametersAndDescriptionView, mainView: pageContentView)
        insertingTwoEqualViewsVertically(firstView: parametersView, secondView: descriptionView, mainView: parametersAndDescriptionView)
        insertingTwoEqualViewsVertically(firstView: parametersFirstLineView, secondView: parametersSecondLineView, mainView: parametersView)
        insertingEqualViewsHorizontally(views: [humidityView, precipitationView, pressureView], mainView: parametersFirstLineView)
        insertingEqualViewsHorizontally(views: [speedWindView, degWindView], mainView: parametersSecondLineView)
        
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
        
        layoutCityView()
    }
    
    private func insertingTwoEqualViewsVertically(firstView: UIView, secondView: UIView, mainView: UIView) {
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
    
    private func insertingEqualViewsHorizontally(views: [UIView], mainView: UIView) {
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
                    maker.width.equalTo(views[index-1])
                }
            } else {
                mainView.addSubview(view)
                view.snp.makeConstraints { maker in
                    maker.top.bottom.right.equalTo(mainView)
                    maker.left.equalTo(views[index - 1].snp.right)
                    maker.width.equalTo(views[index-1])
                }
            }
        }
    }
    
    private func layoutCityView() {
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
        let weatherCurrent = UILabel()
        cityView.addSubview(weatherCurrent)
        weatherCurrent.snp.makeConstraints { maker in
            maker.top.equalTo(locationLabel.snp.bottom).inset(-10)
            maker.left.right.equalTo(view)
            maker.height.equalTo(30)
        }
        weatherCurrent.tag = 2
    }
    
    private func fillingStaticDataParameters() {
        navigationBarView.allSubViewsOf(type: UILabel.self)[0].text = "Today".localize()
        descriptionLabel.text = "Description".localize()
        imageToView(view: humidityView, image: UIImage(named: "humidity"))
        imageToView(view: pressureView, image: UIImage(named: "pressure"))
        imageToView(view: speedWindView, image: UIImage(named: "speedWind"))
        imageToView(view: degWindView, image: UIImage(named: "degWind"))
        imageToView(view: precipitationView, image: UIImage(named: "precipitation"))
    }
    
    private func imageToView(view: UIView, image: UIImage?, color: UIColor = .black) {
        let imageView = view.allSubViewsOf(type: UIImageView.self)[0]
        imageView.image = image
        if color != .black {
            imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
        }
    }
    
    private func updateTodayVC(data: WeatherToday, imageWeatherNow: UIImage?) {
        updateCityViewLabels(data: data)
        updateParametersViewLabels(data: data)
        imageToView(view: cityView, image: imageWeatherNow, color: .yellow)
    }
    
    private func updateCityViewLabels(data: WeatherToday) {
        let labelArray = cityView.allSubViewsOf(type: UILabel.self)
        for label in labelArray {
            switch label.tag {
            case 1:
                guard let city = data.name else { return }
                guard let country = data.sys.country else { return }
                let location = city + ", " + country
                label.text = location
            case 2:
                guard let temp = data.main.temp else { return }
                guard let description = data.weather[0].description else { return }
                label.text = String(Int(temp)) + "°" + " | " + description.firstUppercased()
            default:
                label.text = ""
            }
        }
    }
    
    private func updateParametersViewLabels(data: WeatherToday) {
        if let textHumidity = data.main.humidity {
            humidityView.setTextToLabel(text: String(Int(textHumidity)), measure: " %")
        }
        var textPrecipitation = "0"
        if let textSnow = data.rain?["1h"] {
            textPrecipitation = String(textSnow)
        }
        if let textRain = data.snow?["1h"] {
            textPrecipitation = String(textRain)
        }
        precipitationView.setTextToLabel(text: textPrecipitation, measure: " mm".localize())
        if let textpressure = data.main.pressure {
            pressureView.setTextToLabel(text: String(Int(textpressure)), measure: " hPa".localize())
        }
        if let textWindSpeed = data.wind.speed {
            speedWindView.setTextToLabel(text: String(Int(textWindSpeed)), measure: " km/h".localize())
        }
        if let textdegWind = data.wind.deg?.direction {
            degWindView.setTextToLabel(text: textdegWind.description.localize(), measure: nil)
        }
    }
    
//    private func setTextToLabelThroughView(view: UIView, textString: String?, measure: String? ) {
//        let label = view.allSubViewsOf(type: UILabel.self)[0]
//        guard let text = textString else { return }
//        guard let measure = measure else { return }
//        label.text = text + measure
//    }
    
    private func formatAllText() {
        let labelNavigationBar = navigationBarView.allSubViewsOf(type: UILabel.self)[0]
        labelNavigationBar.format(size: 17)
        let arrayLabels = cityView.allSubViewsOf(type: UILabel.self)
        for label in arrayLabels {
            switch label.tag {
            case 1:
                label.format(size: 17)
            case 2:
                guard let blueColor =  UIColor(named: "MyBlue") else { return }
                label.format(size: 34, weight: .light, textColor: blueColor)
            default:
                label.format(size: 17)
            }
        }
        let arrayLabelsParametersView = parametersView.allSubViewsOf(type: UILabel.self)
        arrayLabelsParametersView.map({$0.format(size: 15)})
        descriptionLabel.format(size: 17, weight: .regular, textColor: .orange)
    }
    
    private func drawLine() {
        navigationBarView.drawLineDifferentColor(colorArray: [.systemPink, .orange, .green, .blue, .yellow, .red],lineWidth: 2, lineLength: 4, lineSpacing:  2, corners: .bottom)
        let imageViews = parametersView.allSubViewsOf(type: UIImageView.self)
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

extension TodayVC: ViewOutputDelegateFirstVC {
    func publishDataFirstVC(dataCurrent: WeatherToday?, imageWeatherNow: UIImage?) {
        guard let dataCurrent = dataCurrent else { return }
        updateTodayVC(data: dataCurrent, imageWeatherNow: imageWeatherNow)
    }
}
