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
    var currentTimeIndex: Int = 0
    var dayTimeArray = [Int]()
    var nightTimeArray = [Int]()
    let networkManager = NetworkService()
    let some = QuoteNetworkService()
    
    
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
    private let kievCityLocationsToChange = ["Kurenivka", "Trukhanov Island", "Chokolivka", "Telychka", "Pushcha-Vodytsya", "Khotiv"]
    let locationManager = CLLocationManager()
    var requiredCityLat: Float = 0
    var requiredCityLon: Float = 0
    var currentLocation: CLLocation?
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var quoteTextView: UITextView!
    
    
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
        foo()
        
        
    }
    
    
    func UIElementsSetup() {
        dayLabel.textColor = .white
        cityLabel.textColor = .white
        conditionLabel.textColor = .white
        temperatureLabel.textColor = .white
        adviceLabel.textColor = .white
        quoteTextView.backgroundColor = UIColor.init(hex: 0x5d9893)
        stackWeather.backgroundColor = UIColor.init(hex: 0x5d9893)
        stackAdvice.backgroundColor = UIColor.init(hex: 0x5d9893)
        view.setGradientBackground(colorOne: UIColor.init(hex: 0x9cfff7),
                                   colorTwo: UIColor.init(hex: 0x000000))
        quoteTextView.textColor = .white
        
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
        print("\(lat)" + "- Latitude")
        print("\(long)" + "- Longitude")
        
        let testLat: Float = 50.450001
        let testLong: Float = 30.523333
        
        
        
        networkManager.getForecast(
            cityLatitude: testLat,
            cityLongitude: testLong) {
            (forecast, error) in
            if let forecast = forecast {
                self.showForecast(data: forecast)
            } else {
                print("error")
            }
        }
    }
    
    func foo() {
        
        var type = ["animal","career","celebrity","dev","explicit","fashion","food","history","money","movie","music","political","religion","science","sport","travel"]
        
        some.getQuote(category: type.randomElement()!) {
            (quotes, error) in
            if let quotes = quotes {
                self.showQuote(data: quotes)
            } else {
                print("error")
            }
        }
    }
    
    func showQuote(data: QuotesRendareble) {
        
        quoteTextView.text = data.quote 
        var frame = self.quoteTextView.frame
        frame.size.height = self.quoteTextView.contentSize.height
        self.quoteTextView.frame = frame
    }
    
    func showForecast(data: ForecastRenderable) {
        
        if kievCityLocationsToChange.contains(data.cityName) {
            cityLabel.text = "Kyiv"
        } else {
            cityLabel.text = data.cityName
        }
        
        
        let doubleTemp: Int = Int(data.temperature - 273)
        
        //MARK:- Sunrise/Sunset formatter:
        print(data.citySunrise)
        print(data.citySunset)
        //MARK:- Sunrise
        let sunrise = Int(data.citySunrise)
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(sunrise))
        let sunriseFormatter = DateFormatter()
        sunriseFormatter.dateStyle = .none
        sunriseFormatter.timeStyle = .short
        sunriseFormatter.dateFormat = "HH:mm"
        let formattedSunriseTime = sunriseFormatter.string(from: sunriseDate)
        print("sunrise \(formattedSunriseTime)")
        let sunriseNeededIndex = formattedSunriseTime.index(formattedSunriseTime.startIndex, offsetBy: 2)
        let indexToUse = formattedSunriseTime[..<sunriseNeededIndex]
        let sunriseTimeIndexToUseInt = Int(indexToUse)!
        
        //    MARK:- Sunset
        let sunset = Int(data.citySunset)
        let sunsetDate = Date(timeIntervalSince1970: TimeInterval(sunset))
        let sunsetFormatter = DateFormatter()
        sunsetFormatter.dateStyle = .none
        sunsetFormatter.timeStyle = .short
        sunsetFormatter.dateFormat = "HH:mm"
        let formattedSunsetTime = sunsetFormatter.string(from: sunsetDate)
        print("sunset \(formattedSunsetTime)")
        let sunsetNeededIndex = formattedSunsetTime.index(formattedSunsetTime.startIndex, offsetBy: 2)
        let sunsetIndexToUse = formattedSunsetTime[..<sunsetNeededIndex]
        let sunsetTimeIndexToUseInt = Int(sunsetIndexToUse)!
        
        //MARK:- Sunrise/Sunset Setup
        
        let dayHours = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 0]
        var sunriseTimeRange = [Int]()
        for i in dayHours {
            while i >= sunriseTimeIndexToUseInt && i <= sunsetTimeIndexToUseInt {
                sunriseTimeRange.append(i)
                break
            }
        }
        print("\(sunriseTimeRange)")
        dayTimeArray = sunriseTimeRange
        dayTimeArray += [dayTimeArray[dayTimeArray.count - 1] + 1]
        nightTimeArray = dayHours.filter {!dayTimeArray.contains($0)}
        
        
        temperatureLabel.text = doubleTemp.description + "℃"
        conditionLabel.text = data.conditions
        weatherIcon(condition: data.conditions)
        //        weatherImage.sd_setImage(with: data.imageUrl)
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
        let currentTimeIndexToUseInt = Int(indexToUse)!
        print(currentTimeIndexToUseInt)
        
        currentTimeIndex = currentTimeIndexToUseInt
        print("\(currentTimeIndex)")
        
    }
    
    @IBAction private func adviceButtonPressed(_ sender: UIButton) {
        sender.pulsate()
        adviceLabel.text = advice.randomElement()
    }
    
    
    func weatherIcon(condition: String) {
        
        for i in dayTimeArray {
            if currentTimeIndex == i && condition == "Clear"  {
                weatherImage.image = #imageLiteral(resourceName: "clearDay")
            } else if currentTimeIndex == i && condition == "Thunderstorm" {
                weatherImage.image = #imageLiteral(resourceName: "stormDay")
            } else  if currentTimeIndex == i && condition == "Drizzle" {
                weatherImage.image = #imageLiteral(resourceName: "rain")
            } else  if currentTimeIndex == i && condition == "Rain" {
                weatherImage.image = #imageLiteral(resourceName: "rain")
            } else  if currentTimeIndex == i && condition == "Snow" {
                weatherImage.image = #imageLiteral(resourceName: "snowDay")
            } else  if currentTimeIndex == i && condition == "Mist" {
                weatherImage.image = #imageLiteral(resourceName: "fogDay")
            } else  if currentTimeIndex == i && condition == "Fog" {
                weatherImage.image = #imageLiteral(resourceName: "fogDay")
            }  else  if currentTimeIndex == i && condition == "Clouds" {
                weatherImage.image = #imageLiteral(resourceName: "cloudsDay")
            }
        }
        
        for i in nightTimeArray {
            if currentTimeIndex == i && condition == "Clear" {
                weatherImage.image = #imageLiteral(resourceName: "clearNight")
            } else if currentTimeIndex == i && condition == "Thunderstorm" {
                weatherImage.image = #imageLiteral(resourceName: "thunderNight")
            } else  if currentTimeIndex == i && condition == "Drizzle" {
                weatherImage.image = #imageLiteral(resourceName: "rain")
            } else  if currentTimeIndex == i && condition == "Rain" {
                weatherImage.image = #imageLiteral(resourceName: "rain")
            } else  if currentTimeIndex == i && condition == "Snow" {
                weatherImage.image = #imageLiteral(resourceName: "snowNight")
            } else  if currentTimeIndex == i && condition == "Mist" {
                weatherImage.image = #imageLiteral(resourceName: "fogNight")
            } else  if currentTimeIndex == i && condition == "Fog" {
                weatherImage.image = #imageLiteral(resourceName: "fogNight")
            }  else  if currentTimeIndex == i && condition == "Clouds" {
                weatherImage.image = #imageLiteral(resourceName: "cloudNight")
            }
        }
    }
    
}
