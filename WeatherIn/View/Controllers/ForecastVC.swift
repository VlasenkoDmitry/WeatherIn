import Foundation
import UIKit

class ForecastVC: UIViewController {
    let presenter = PresenterForecastVC()
    private let statusBarView = UIView()
    private let navigationBarView = UIView()
    private let tableView = UITableView()
    private let heightStandartCellInTableView: CGFloat = 100
    private var cellsWithDaysOfWeek: Set<Int> = []
    private var weatherForecast: WeatherForecastFiveDays?
    private var arrayImages: [UIImage?]?
    private var numberOfRowsInSection: Int {
        get {
            if let number = weatherForecast?.list.count {
                return number
            } else {
                return 20
            }
        }
    }
    private weak var viewInputDelegate: ViewInputDelegateForecastVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkTableView()
        linkPresenter()
        layout()
    }
    
    private func linkTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(FDForecastTableViewCell.self, forCellReuseIdentifier: "FDForecastTableViewCell")
    }
    
    private func linkPresenter() {
        presenter.setViewOutputDelegate(viewOutputDelegate: self)
        self.viewInputDelegate = presenter
    }
    
    private func layout() {
        view.setLayoutStatusBarView(bar: statusBarView)
        view.setLayoutNavigationBar(navigationBar: navigationBarView, topElement: statusBarView)
        setLayoutTableView()
    }
    
    private func setLayoutTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(navigationBarView.snp.bottom)
            maker.left.right.bottom.equalTo(view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillNavigationBar()
        self.view.backgroundColor = .white
        presenter.transmitWeatherDataForecastToForecastVC()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationBarView.drawLineDifferentColor(colorArray: [.systemPink, .orange, .green, .blue, .yellow, .red],lineWidth: 2, lineLength: 4, lineSpacing:  2, corners: .bottom)
    }
    
    private func updateForecastVC(weatherForecast: WeatherForecastFiveDays, arrayImages: [UIImage?]?) {
        self.weatherForecast = weatherForecast
        self.arrayImages = arrayImages
        fillNavigationBar()
        tableView.reloadData()
    }
    
    private func fillNavigationBar() {
        navigationBarView.getAllSubViewsOf(type: UILabel.self)[0].text = weatherForecast?.city.name
        navigationBarView.getAllSubViewsOf(type: UILabel.self)[0].format(size: 17)
    }
}

//  delegates to work with table view
extension ForecastVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellsWithDaysOfWeek.contains(indexPath.row) == false ,indexPath.row == 0 {
            return 0
        }
        if cellsWithDaysOfWeek.contains(indexPath.row) {
            return heightStandartCellInTableView / 2
        } else {
            return heightStandartCellInTableView
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FDForecastTableViewCell", for: indexPath) as? FDForecastTableViewCell else { return UITableViewCell() }
        clearCell(cell: cell)
        // before that in dataFiveDays was add extra data to devide by days of week. If data is nil - we create special cell in tableview
        if let data = weatherForecast?.list[indexPath.row] {
            cell.tag = 2
            cell.configureForecastCell(data: data, image: arrayImages?[indexPath.row])
        } else {
            if let row = weatherForecast?.list[indexPath.row + 1] {
                cell.configureNameDayCell(row: row, indexRow: indexPath.row)
                cellsWithDaysOfWeek.insert(indexPath.row)
            }
        }
        return cell
    }

    // clean all Labels and ImageViews before reuse
    private func clearCell(cell: FDForecastTableViewCell) {
        for views in cell.getAllSubViewsOf(type: UILabel.self) {
            views.removeFromSuperview()
        }
        for views in cell.getAllSubViewsOf(type: UIImageView.self) {
            views.removeFromSuperview()
        }
    }
}

// update tableview cells after adding days of week in dataFiveDays(PresenterForecastVC)
extension ForecastVC: ViewOutputDelegateForecastVC {
    func publishDataForecastVC(weatherForecast: WeatherForecastFiveDays, arrayImages: [UIImage?]?) {
        updateForecastVC(weatherForecast: weatherForecast, arrayImages: arrayImages)
    }
}
