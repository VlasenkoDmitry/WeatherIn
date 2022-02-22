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
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        fillingStaticData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        horizontalDivisionBlockEqual(views: [humidityView,precipitationView,pressureView], mainView: detailsFirstLineView)
        horizontalDivisionBlockEqual(views: [speedWindView,degWindView], mainView: detailsSecondLineView)
        
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
    
    func verticalDivisionBlockEqual(firstView: UIView, secondView: UIView, mainView: UIView) {
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
    
    private func horizontalDivisionBlockEqual(views:[UIView], mainView: UIView) {
        for (index,view) in views.enumerated() {
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
    
    func fillingStaticData() {
        navigationBarView.allSubViewsOf(type: UILabel.self)[0].text = "Today"
        shareLabel.text = "Share"
        installationImage(view: humidityView, image: UIImage(named: "humidity"))
        installationImage(view: pressureView, image: UIImage(named: "pressure"))
        installationImage(view: speedWindView, image: UIImage(named: "speedWind"))
        installationImage(view: degWindView, image: UIImage(named: "degWind"))
        installationImage(view: precipitationView, image: UIImage(named: "precipitation"))
    }
    
    private func installationImage(view: UIView,image: UIImage?,color: UIColor = .black) {
        let imageView = view.allSubViewsOf(type: UIImageView.self)[0]
        imageView.image = image
        if color != .black {
            imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
        }
    }
}
