//
//  ViewController.swift
//  Your news today
//
//  Created by kenjimaeda on 03/11/22.
//

import UIKit
import CoreLocation

class NewsAppController: UIViewController {
	
	//MARK: - IBOutlet
	@IBOutlet weak var labWind: UILabel!
	@IBOutlet weak var labHumidity: UILabel!
	@IBOutlet weak var temperatureMax: UILabel!
	@IBOutlet weak var labTemperature: UILabel!
	@IBOutlet weak var labDayMonth: UILabel!
	@IBOutlet weak var labCity: UILabel!
	
	//MARK: - Vars
	var locationManager = CLLocationManager()
	
	//url de imagens
	//http://openweathermap.org/img/wn/<codigo>@2x.png
	
	override func viewDidLoad() {
		super.viewDidLoad()
		locationManager.delegate = self
		
		// Do any additional setup after loading the view.
		populetedView()
		
		
		locationManager.requestAlwaysAuthorization()
		
		locationManager.requestLocation()
	}
	
	func populetedView() {
		
		
	}
	
	
}

//MARK: - UITableViewDataSource,UITableViewDelegate
extension NewsAppController: UITableViewDataSource,UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cellNews", for: indexPath)
		
		return cell
	}
	
	
}

//MARK: - CLLocationManagerDelegate
extension NewsAppController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		if let location = locations.last {
			let latitude = location.coordinate.latitude
			let longitude = location.coordinate.longitude
			
			
			//para pegar address
			//referencia
			//https://stackoverflow.com/questions/41358423/swift-generate-an-address-format-from-reverse-geocoding
			var coordinate = CLLocationCoordinate2D()
			let geocoder = CLGeocoder()
			coordinate.latitude = latitude
			coordinate.longitude = longitude
			
			var location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
			
			geocoder.reverseGeocodeLocation(location) { placemarks, error in
				
				if error == nil {
					let pm = placemarks! as [CLPlacemark]
					
					if pm.count > 0  {
						let pm = placemarks![0]
						guard let city = pm.locality, let state = pm.administrativeArea else {return}
						
						self.labCity.text = "\(city), \(state)"
						print(pm.country) // pais
						print(pm.locality) // cidade
						print(pm.subLocality) // bairro
						print(pm.administrativeArea)// estado
				
					}
				
				}else {
					
					print(error?.localizedDescription)
					
				}
				
			}
			
			locationManager.stopUpdatingLocation()
			
			
		}
		
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
	
	
}

