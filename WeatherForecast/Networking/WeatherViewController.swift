//
//  WeatherViewController.swift
//  WeatherForecast
//
//  Created by Adebayo Adesokan on 30.06.2021.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController,  CLLocationManagerDelegate {
    let geocoder = CLGeocoder()
    var weatherResult = [Answer]()
    var usersCity : String? = ""
    var model = [Model]()
    var cityArray = [String]()
    let transparentView2 = UIView()
    let tableView = UITableView()
    
    @IBOutlet weak var citiesField: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        
    
        locationManager.requestAlwaysAuthorization()

        print("did load")
        print(locationManager)

      
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("no access")
                print("Location services not enabled")
                self.citiesField.isHidden = false
                self.citiesField.setTitle("Choose a city", for: .normal)
                
            case .authorizedAlways, .authorizedWhenInUse, .authorized :
                print("access")
                locationManager.startUpdatingLocation()
            default :
                break;
            }
           
        } else {
            print("Location services not enabled")
            self.citiesField.isHidden = false
            self.citiesField.setTitle("Choose a city", for: .normal)
        }


    }
    lazy var locationManager: CLLocationManager = {
           var _locationManager = CLLocationManager()
           _locationManager.delegate = self
           _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
           _locationManager.activityType = . automotiveNavigation
           _locationManager.distanceFilter = 10.0  // Movement threshold for new events
         //  _locationManager.allowsBackgroundLocationUpdates = true // allow in background

           return _locationManager
       }()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("hi")
       if let currentLocation = locations.last {
        guard let locvalue : CLLocationCoordinate2D  = locationManager.location?.coordinate else {return}
        let location = CLLocation(latitude: locvalue.latitude, longitude: locvalue.longitude)
        print("Current location: \(currentLocation)")
        self.locationManager.stopUpdatingLocation()
        
        geocoder.reverseGeocodeLocation(location, completionHandler:  { (placemarks, error) in
            
            if error == nil {
                if let firstlocation = placemarks?[0] {
                    if let cityname = firstlocation.locality {
                        self.usersCity = cityname
                        WeatherService.shared.getCityWeather(city: cityname) { (results) in
                            self.cityLabel.text = results.name
                            self.commentLabel.text = results.weather?[0].weatherDescription
              
                            print(results)
                        }
                    print("my city name is \(cityname)")
                        let tabvc = self.tabBarController?.viewControllers?[1] as! ForecastViewController

                        tabvc.city = cityname
 
                   
                }
                }
            }
        })
       }
   }

//   // 2
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print("this is \(error)")

   }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        self.citiesField.setTitle("Choose a city", for: .normal)
        CityAPI.shared.getCities { (models) in
            self.model.append(contentsOf: models)
            print("model is \(self.model)")
            for i in 0..<self.model.count {
                self.cityArray.append(self.model[i].city ?? "")
            }
           
            
        }

       
    }
    

    
    @IBAction func citiesClicked(_ sender: Any) {
        addTransparentView2(frames: citiesField.frame)
    }
    
}
extension WeatherViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.textAlignment = .left
        cell.textLabel?.text = cityArray[indexPath.row]
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
          
            citiesField.setTitle(cityArray[indexPath.row], for: .normal)
            WeatherService.shared.getCityWeather(city: cityArray[indexPath.row]) { (results) in
                self.cityLabel.text = results.name
                self.commentLabel.text = results.weather?[0].weatherDescription
  
                print(results)
            }
        print("my city name is \(cityArray[indexPath.row])")
            let tabvc = self.tabBarController?.viewControllers?[1] as! ForecastViewController

            tabvc.city = cityArray[indexPath.row]
            removeTransparentView()
            
        }
    }
    func addTransparentView2(frames: CGRect) {
             let window = UIApplication.shared.keyWindow
        transparentView2.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView2)
             
             tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
             tableView.layer.cornerRadius = 5
             
             transparentView2.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
//        let scrollpoint = CGPoint(x: 0, y: tableView.contentSize.height - tableView.frame.size.height)
//        tableView.setContentOffset(scrollpoint, animated: true)
             let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
             transparentView2.addGestureRecognizer(tapgesture)
             transparentView2.alpha = 0
             UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                 self.transparentView2.alpha = 0.5
                 self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5 , width: frames.width, height: CGFloat(self.cityArray.count * 30))
             }, completion: nil)
         }
    @objc func removeTransparentView() {
             let frames = citiesField.frame
             UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                 self.transparentView2.alpha = 0
                 self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
             
             }, completion: nil)
         }
}
