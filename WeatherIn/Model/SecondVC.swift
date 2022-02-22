import Foundation
import UIKit

class SecondVC: UIViewController {
    private var statusBarView = UIView()
    private var navigationBarView = UIView()
    private var tableView = UITableView()
    private var shortTableCellsArray: Set<Int> = []
    private var dataFiveDays: WeatherFiveDays?
    private var arrayImages: [UIImage?]?
    private var numberSelectedRow: Int?
    private var numberOfRowsInSection: Int {
        get {
            if let count = dataFiveDays?.list.count {
                return count
            } else {
                return 20
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(FDForecastTableViewCell.self, forCellReuseIdentifier: "FDForecastTableViewCell")
        layout()
    }
    
    private func layout() {
        view.layoutStatusBar(bar: statusBarView)
        view.layoutNavigationBar(navigationBar: navigationBarView, statusBar: statusBarView)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(navigationBarView.snp.bottom)
            maker.left.right.bottom.equalTo(view)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func update(dataFiveDays: WeatherFiveDays, arrayImages: [UIImage?]?){
        self.dataFiveDays = dataFiveDays
        self.arrayImages = arrayImages
        tableView.reloadData()
    }
}


extension SecondVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if shortTableCellsArray.contains(indexPath.row) {
            return 50
        } else {
            return 100
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
        if let data = dataFiveDays?.list[indexPath.row], let image = arrayImages?[indexPath.row] {
            cell.tag = 2
            cell.configureForecastCell(data: data,image: image)
        } else {
            shortTableCellsArray.insert(indexPath.row)
            guard let row = dataFiveDays?.list[indexPath.row + 1] else { return cell }
            cell.configureNameDayCell(row: row, indexRow: indexPath.row)
        }
        return cell
    }
    
    func clearCell(cell: FDForecastTableViewCell) {
        for views in cell.allSubViewsOf(type: UILabel.self) {
            views.removeFromSuperview()
        }
        for views in cell.allSubViewsOf(type: UIImageView.self) {
            views.removeFromSuperview()
        }
    }
}
