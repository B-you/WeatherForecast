//
//  ForecastViewController.swift
//  WeatherForecast
//
//  Created by Adebayo Adesokan on 30.06.2021.
//

import UIKit
import CoreData

class ForecastViewController: UIViewController {
    
    
    @IBOutlet weak var weatherTableView: UITableView!
    var city : String? = ""
    var result = [Answer]()
    var mylist = [List]()
    var arrayOflist = [List]()
    func retrieveData() {

           //As we know that container is set up in the AppDelegates so we need to refer that container.
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

           //We need to create a context from this container
           let managedContext = appDelegate.persistentContainer.viewContext

           //Prepare the request of type NSFetchRequest  for the entity
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyList")

           do {
               let result = try managedContext.fetch(fetchRequest)
            arrayOflist.removeAll()
               //arrUserDetails.removeAll()
               for data in result as! [NSManagedObject] {
                print("okokokokokok")
                   print(data.value(forKey: "dttxt") as! String)
                print(data.value(forKey: "temp_min") as! Double)
                print(data.value(forKey: "temp_max") as! Double)
                
                arrayOflist.append(List(dt: 0, main: MainClass(temp: 0.9, feelsLike: 0.0, tempMin: data.value(forKey: "temp_min") as? Double, tempMax: data.value(forKey: "temp_max") as? Double, pressure: 0, seaLevel: 0, grndLevel: 0, humidity: 0, tempKf: 0.0), weather: [Weather(id: 0, main: MainEnum(rawValue: ""), weatherDescription: "", icon: "")], clouds: Clouds(all: 0), wind: Wind(speed: 0.0, deg: 0, gust: 0.0), visibility: 0, pop: 0.0, sys: Sys(pod: Pod(rawValue: "")), dtTxt: data.value(forKey: "dttxt") as? String, snow: Snow(the3H: 0.0)))
               }
               weatherTableView.reloadData()

           } catch {

               print("Failed")
           }
       }
    func createData(list : [List]){

          //As we know that container is set up in the AppDelegates so we need to refer that container.
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
       // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
          //We need to create a context from this container
          let managedContext = appDelegate.persistentContainer.viewContext

          //Now let’s create an entity and new user records.
          let userEntity = NSEntityDescription.entity(forEntityName: "MyList", in: managedContext)!

          //final, we need to add some data to our newly created record for each keys using


          let entity = NSManagedObject(entity: userEntity, insertInto: managedContext)
        
        for i in 0..<list.count {
            entity.setValue(list[i].dtTxt, forKey: "dttxt")
            entity.setValue(list[i].main?.tempMin, forKey: "temp_min")
            entity.setValue(list[i].main?.tempMax, forKey: "temp_max")
        }
//          entity.setValue(dtxt, forKeyPath: "dttxt")
//          entity.setValue(tempmin, forKey: "temp_min")
//          entity.setValue(tempmax, forKey: "temp_max")

          retrieveData()
          //Now we have set all the values. The next step is to save them inside the Core Data

          do {
              try managedContext.save()

          } catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
          }
      }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mylist.removeAll()
        mylist = []
        if city != "" {
      
        
            WeatherService.shared.getCountryWeather(city: city!, dt: 10000000) { (results) in
                self.result.append(results)
               
                for i in 0..<self.result.count {
                    self.mylist.append(contentsOf: self.result[i].list!)
                    
                   
                }
                self.createData(list: results.list!)
//                self.createData(list: self.mylist)
                self.weatherTableView.reloadData()
                print(self.result)
            }
        
        // Do any additional setup after loading the view.
        } else {
            print("city is empty")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
 
    }
    

}
extension ForecastViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! ForecastTableViewCell
        cell.titleLabel.text = mylist[indexPath.row].dtTxt
        cell.maximumLabel.text = "Maximum temperature in \(city ?? "") \(String(describing: mylist[indexPath.row].main?.tempMax)) C)"
        cell.minimumLabel.text = "Minimum temperature in \(city ?? "") \(String(describing: mylist[indexPath.row].main?.tempMin)) C"

        return cell
    
    }
    
    
}
