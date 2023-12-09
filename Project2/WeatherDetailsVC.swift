//
//  WeatherDetailsVC.swift
//  Project2
//
//  Created by Akash Shrestha on 2023-12-08.
//

import UIKit

class WeatherDetailsVC: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblWeatherStatus: UILabel!
    @IBOutlet weak var lblHighLow: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    
    var getWeatherDetails: WeatherResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfig()
        tableConfig()
    }
    
    private func initialConfig() {
        lblName.text = getWeatherDetails?.location?.name
        lblTemp.text = "\(getWeatherDetails?.current?.temp_c ?? 0.0)"
        lblWeatherStatus.text = getWeatherDetails?.current?.condition?.text
        lblHighLow.text = "H: \(getWeatherDetails?.forecast?.forecastday.first?.day.maxtemp_c ?? 0.0)°  L: \(getWeatherDetails?.forecast?.forecastday.first?.day.mintemp_c ?? 0.0)°"
    }
    
    private func tableConfig() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(WeatherDetailsTableViewCell.nib(), forCellReuseIdentifier: WeatherDetailsTableViewCell.identifier)
    }

}

extension WeatherDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getWeatherDetails?.forecast?.forecastday.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: WeatherDetailsTableViewCell.identifier, for: indexPath) as! WeatherDetailsTableViewCell
        let model = getWeatherDetails?.forecast?.forecastday[indexPath.item]
        cell.selectionStyle = .none
        cell.imgView.getWeatherImage(code: model?.day.condition.code ?? 0)
        cell.lblDetails.text = "\(model?.date ?? "")   H:\(model?.day.maxtemp_c ?? 0.0) L: \(model?.day.mintemp_c ?? 0.0)"
        return cell
    }
}
