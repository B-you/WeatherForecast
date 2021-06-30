//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by Adebayo Adesokan on 30.06.2021.
//

import Foundation
//import RealmSwift

struct Answer:  Codable {
  var cod: String?
    var message : Int?
    var  cnt: Int = 0
     var list: [List]?
    var city: City?
}

// MARK: - City
struct City:  Codable {
     var id: Int?
     var name: String?
     var coord: Coord?
     var country: String?
     var population : Int?
    var timezone : Int?
    var sunrise : Int?
     var sunset: Int?
}

// MARK: - Coord
struct Coord:   Codable {
     var lat : Double?
  var lon: Double?
}

// MARK: - List
struct List:  Codable {
     var dt: Int?
    var main: MainClass?
     var weather: [Weather]?
    var clouds: Clouds?
     var wind: Wind?
     var visibility: Int?
     var pop: Double?
     var sys: Sys?
     var dtTxt: String?
    var  snow: Snow?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case snow
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    var all: Int?
}

// MARK: - MainClass
struct MainClass:   Codable {
     var temp : Double?
 var feelsLike : Double?
 var tempMin :  Double?
 var tempMax: Double?
   var pressure : Int?
     var seaLevel : Int?
    var grndLevel : Int?
                     var humidity: Int?
    var tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Snow
struct Snow:  Codable {
     var the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys:  Codable {
    var pod: Pod?
}
//class Pod : Object, Codable {
//    @objc dynamic var d : String = ""
//    @objc dynamic var n : String = ""

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}
//}
// MARK: - Weather
struct Weather: Codable {
     var id: Int?
     var main: MainEnum?
    var weatherDescription : String?
                       var icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
//class MainEnum : Object , Codable {
//    @objc dynamic var clear : String = "Clear"
//    @objc dynamic var clouds : String = "Clouds"
//    @objc dynamic var snow : String = "Snow"
//    @objc dynamic var rain : String = "Rain"

enum MainEnum:  String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case snow = "Snow"
    case rain = "Rain"
}
//}

// MARK: - Wind
struct Wind: Codable {
   var speed: Double?
   var deg: Int?
    var gust : Double?
}



