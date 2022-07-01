import Foundation

protocol ViewInputDelegateMainVC: AnyObject {
    func setDownloadedDataToPresentersViewControllers(firstVC: TodayVC,secondVC: ForecastVC)
}
