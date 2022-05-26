import Foundation
import UIKit

class FirstVC: UIViewController {
    private var statusBarView = UIView()
    private var navigationBarView = UIView()
    private var mainView = UIView()
    private var cityView = UIView()
    private var detailsShareView = UIView()
    private var detailsView = UIView()
    private var shareView = UIView()
    private var detailsFirstLineView = UIView()
    private var detailsSecondLineView = UIView()
    private var humidityView = UIView()
    private var precipitationView = UIView()
    private var pressureView = UIView()
    private var speedWindView = UIView()
    private var degWindView = UIView()
    private var shareLabel = UILabel()
    var presenter = PresenterFirstVC()
    private weak var viewInputputDelegate: ViewInputDelegateFirstVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        fillingStaticData()
        formatAllText()
        addRecognizer(label: shareLabel)
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
        view.addSubview(mainView)
        mainView.snp.makeConstraints { maker in
            maker.top.equalTo(navigationBarView.snp.bottom)
            maker.left.right.equalToSuperview().inset(0)
            maker.bottom.equalToSuperview().inset(100)
        }
        
        verticalDivisionBlockEqual(firstView: cityView, secondView: detailsShareView, mainView: mainView)
        verticalDivisionBlockEqual(firstView: detailsView, secondView: shareView, mainView: detailsShareView)
        verticalDivisionBlockEqual(firstView: detailsFirstLineView, secondView: detailsSecondLineView, mainView: detailsView)
        horizontalDivisionBlockEqual(views: [humidityView, precipitationView, pressureView], mainView: detailsFirstLineView)
        horizontalDivisionBlockEqual(views: [speedWindView, degWindView], mainView: detailsSecondLineView)
        
        let builder = BuilderDetailsView()
        let director = DirectorViewsOfDetailsView(builder: builder)
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
        
        
        shareView.addSubview(shareLabel)
        shareLabel.snp.makeConstraints { maker in
            maker.top.left.right.bottom.equalTo(shareView)
        }
        
        layoutViewAsMain(view: cityView)
    }
    
    private func verticalDivisionBlockEqual(firstView: UIView, secondView: UIView, mainView: UIView) {
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
    
    private func horizontalDivisionBlockEqual(views: [UIView], mainView: UIView) {
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
    
    private func layoutViewAsMain(view: UIView) {
        let imageView = UIImageView()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.top.equalTo(view.snp.top).inset(100)
            maker.center.equalTo(view)
            maker.width.equalTo(imageView.snp.height)
        }
        let locationLabel = UILabel()
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { maker in
            maker.top.equalTo(imageView.snp.bottom).inset(-10)
            maker.left.right.equalTo(view)
            maker.height.equalTo(30)
        }
        locationLabel.tag = 1
        let weatherCurrent = UILabel()
        view.addSubview(weatherCurrent)
        weatherCurrent.snp.makeConstraints { maker in
            maker.top.equalTo(locationLabel.snp.bottom).inset(-10)
            maker.left.right.equalTo(view)
            maker.height.equalTo(30)
        }
        weatherCurrent.tag = 2
    }
    
    private func fillingStaticData() {
        navigationBarView.allSubViewsOf(type: UILabel.self)[0].text = "Today"
        shareLabel.text = "Share"
        installationImage(view: humidityView, image: UIImage(named: "humidity"))
        installationImage(view: pressureView, image: UIImage(named: "pressure"))
        installationImage(view: speedWindView, image: UIImage(named: "speedWind"))
        installationImage(view: degWindView, image: UIImage(named: "degWind"))
        installationImage(view: precipitationView, image: UIImage(named: "precipitation"))
    }
    
    private func installationImage(view: UIView, image: UIImage?, color: UIColor = .black) {
        let imageView = view.allSubViewsOf(type: UIImageView.self)[0]
        imageView.image = image
        if color != .black {
            imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
        }
    }
    
    private func updateVC(data: WeatherCurrent, imageWeatherNow: UIImage?) {
        updateMainViewLabels(data: data)
        if let textHumidity = data.main.humidity {
            installationTextLabel(view: humidityView, textString: String(Int(textHumidity)), measure: " %")
        }
        var textPrecipitation = "0"
        if let textSnow = data.rain?["1h"] {
            textPrecipitation = String(textSnow)
        }
        if let textRain = data.snow?["1h"] {
            textPrecipitation = String(textRain)
        }
        installationTextLabel(view: precipitationView, textString: textPrecipitation, measure: " mm")
        if let textpressure = data.main.pressure {
            installationTextLabel(view: pressureView, textString: String(Int(textpressure)), measure: " pHA")
        }
        if let textWindSpeed = data.wind.speed {
            installationTextLabel(view: speedWindView, textString: String(Int(textWindSpeed)), measure: " km/h")
        }
        if let textdegWind = data.wind.deg?.direction {
            installationTextLabel(view: degWindView, textString: textdegWind.description, measure: "")
        }
        installationImage(view: cityView, image: imageWeatherNow, color: .yellow)
    }
    
    private func updateMainViewLabels(data: WeatherCurrent) {
        let labelArray = cityView.allSubViewsOf(type: UILabel.self)
        for label in labelArray {
            switch label.tag {
            case 1:
                guard let city = data.name else { return }
                guard let country = data.sys.country else { return }
                let location = city + " ," + country
                label.text = location
            case 2:
                guard let temp = data.main.temp else { return }
                guard let main = data.weather[0].main else { return }
                label.text = String(Int(temp)) + "°" + " | " + main
            default:
                label.text = ""
            }
        }
    }
    
    private func installationTextLabel(view: UIView, textString: String?, measure: String? ) {
        let label = view.allSubViewsOf(type: UILabel.self)[0]
        guard let text = textString else { return }
        guard let measure = measure else { return }
        label.text = text + measure
    }
    
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
        let arrayLabelsDetailsView = detailsView.allSubViewsOf(type: UILabel.self)
        arrayLabelsDetailsView.map({$0.format(size: 15)})
        shareLabel.format(size: 17, weight: .regular, textColor: .orange)
    }
    
    private func drawLine() {
        navigationBarView.drawLineDifferentColor(colorArray: [.systemPink, .orange, .green, .blue, .yellow, .red],lineWidth: 2, lineLength: 4, lineSpacing:  2, corners: .bottom)
        let imageViews = detailsView.allSubViewsOf(type: UIImageView.self)
        for imageView in imageViews {
            imageView.drawDashLine(strokeColor: .gray, lineLength: 4, lineSpacing:  2, distanceBorder: 3, corners: .all)
        }
        detailsView.drawDashLine(strokeColor: .gray, lineLength: 4, lineSpacing: 1, corners: .bottom, trimLine: self.view.frame.size.width / 3)
        detailsView.drawDashLine(strokeColor: .gray, lineLength: 4, lineSpacing: 1, corners: .top, trimLine: self.view.frame.size.width / 3)
    }
    
    private func addRecognizer(label: UILabel) {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        shareView.addGestureRecognizer(recognizer)
    }
    
    @objc private func tapDetected() {
        showAlert(title: "Ok", text: "Good weather...")
    }
}

extension FirstVC: ViewOutputDelegateFirstVC {
    func publishDataFirstVC(dataCurrent: WeatherCurrent?, imageWeatherNow: UIImage?) {
        guard let dataCurrent = dataCurrent else { return }
        updateVC(data: dataCurrent, imageWeatherNow: imageWeatherNow)
    }
}
