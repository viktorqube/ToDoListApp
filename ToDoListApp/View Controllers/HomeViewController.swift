//
//  HomeViewController.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 07.10.2020.
//



import UIKit
//import SDWebImage
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate{
    
    
    // MARK: - Properties
    var indexToShowDayNightIcon: Int = 0
    let networkManager = NetworkService()
    private var advice = ["Задача сама себя не сделает!",
                          "Или ты задачу, или лень тебя!",
                          "Встань и делай!",
                          "Ты еще тут?",
                          "Хватит тыкать!",
                          "Move, Move, Move!",
                          "Сделал дело, сделай еще!",
                          "Лень хороша, когда ты спишь!",
                          "Поставил цель - делай!",
                          "Все проблемы в твоей голове!",
    ]
    // MARK: - Location Properties
    let locationManager = CLLocationManager()
    var requiredCityLat: Float = 0
    var requiredCityLon: Float = 0
    var currentLocation: CLLocation?
    
    
    //MARK: - Outlets
    @IBOutlet weak var stackWeather: UIStackView!
    @IBOutlet weak private var stackAdvice:  UIStackView!
    @IBOutlet weak var adviceLabel: UITextView!
    @IBOutlet weak private var adviceButton: UIButton!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    //MARK: - Weather Outlets
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIElementsSetup()
        locationSetup()
        dateAndTimeSetup()
    }
    
    func UIElementsSetup() {
        dayLabel.textColor = .white
        cityLabel.textColor = .white
        conditionLabel.textColor = UIColor.init(hex: 0xf69272)
        temperatureLabel.textColor = UIColor.init(hex: 0xf69272)
        adviceLabel.textColor = UIColor.init(hex: 0xf69272)
        stackWeather.backgroundColor = UIColor.init(hex: 0x9cfff7)
        stackAdvice.backgroundColor = UIColor.init(hex: 0x9cfff7)
        view.setGradientBackground(colorOne: UIColor.init(hex: 0x9cfff7),
                                   colorTwo: UIColor.init(hex: 0xf69272))
    }
    
    //MARK: - Location Services:
    func locationSetup() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = Float(currentLocation.coordinate.longitude)
        let lat = Float(currentLocation.coordinate.latitude)
        
        networkManager.getForecast(
            cityLatitude: lat,
            cityLongitude: long) {
            (forecast, error) in
            if let forecast = forecast {
                self.showForecast(data: forecast)
            } else {
                print("error")
            }
        }
    }
    
    
    
    //MARK: - Date and Time SetUp
    func dateAndTimeSetup() {
        //MARK: - Date SetUp
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let dateString = formatter.string(from: currentDate)
        dayLabel.text = dateString
        //MARK: - Time SetUp to Show Day/Night Label
        let setTime = DateFormatter()
        setTime.timeStyle = .short
        setTime.dateFormat = "HH:mm"
        let timeAsString = setTime.string(from: Date())
        let neededIndex = timeAsString.index(timeAsString.startIndex, offsetBy: 2)
        let indexToUse = timeAsString[..<neededIndex]
        let timeIndexToUseInt = Int(indexToUse)!
        print(timeIndexToUseInt)
        indexToShowDayNightIcon = timeIndexToUseInt
    }
    
    @IBAction private func adviceButtonPressed(_ sender: UIButton) {
        sender.pulsate()
        adviceLabel.text = advice.randomElement()
    }
    
    func weatherIcon(condition: String) {
        let day = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
        let night = [21, 22, 23, 00, 01, 02, 03, 04, 05]
        for i in day {
            if condition == "Clear" && indexToShowDayNightIcon == i {
                weatherImage.image = #imageLiteral(resourceName: "sun")
            }
        }
        for x in night.reversed() {
            if condition == "Clear" && indexToShowDayNightIcon == x {
                weatherImage.image = #imageLiteral(resourceName: "night")
            }
        }
        if condition == "Thunderstorm" {
            weatherImage.image = #imageLiteral(resourceName: "storm")
        } else  if condition == "Drizzle" {
            weatherImage.image = #imageLiteral(resourceName: "rain")
        } else  if condition == "Rain" {
            weatherImage.image = #imageLiteral(resourceName: "rain")
        } else  if condition == "Snow" {
            weatherImage.image = #imageLiteral(resourceName: "snow")
        } else  if condition == "Mist" {
            weatherImage.image = #imageLiteral(resourceName: "fog")
        } else  if condition == "Fog" {
            weatherImage.image = #imageLiteral(resourceName: "fog")
        }  else  if condition == "Clouds" {
            weatherImage.image = #imageLiteral(resourceName: "clouds")
        }
    }
    
    private func showForecast(data: ForecastRenderable) {
        var doubleTemp: Int = Int(data.temperature - 273)
        cityLabel.text = data.cityName
        temperatureLabel.text = doubleTemp.description + "℃"
        conditionLabel.text = data.conditions
        weatherIcon(condition: data.conditions)
        //        weatherImage.sd_setImage(with: data.imageUrl)
    }
    
    
    
}


