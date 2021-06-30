//
//  Model.swift
//  WeatherForecast
//
//  Created by Adebayo Adesokan on 30.06.2021.
//

import Foundation

struct Model : Codable  {
var city : String?
var country : String?
var localized_country_name : String?
var name_string : String?
var zip: String?
var lat : Float?
var lon : Float?
init(city : String, country : String,localized_country_name  : String, name_string : String, zip : String, lat : Float, lon : Float ) {
    self.city = city
    self.country = country
    self.localized_country_name = localized_country_name
    self.name_string = name_string
    
    self.zip = zip
    self.lat = lat
    self.lon = lon
}
}
