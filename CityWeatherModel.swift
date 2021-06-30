//
//  CityWeatherModel.swift
//  WeatherForecast
//
//  Created by Adebayo Adesokan on 30.06.2021.
//

import Foundation
struct CityWeatherModel : Codable {
    var base : String?
    let clouds: Clouds?
    let cod : Int?
    let coord : Coord?
    let dt : Int64?
    let id : Int64?
    let main : Main?
    let name : String?
    let sys: System?
    var timezone : Int64?
    var visibility : Int64?
    var weather : [Weather]?
    var wind : Wind?
    
}
struct System : Codable {
    var country : String?
    var id : Int64?
    var sunrise : Int64?
    var sunset : Int64?
    var type : Int?
}

struct Main : Codable {
    var   feels_like : Double?
    var humidity : Int?
    var pressure : Int?
    var temp : Double?
    var temp_max : Double?
    var temp_min : Double?
}




