//
//  ViewController.swift
//  Your news today
//
//  Created by kenjimaeda on 03/11/22.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class NewsAppController: UIViewController {
	
	//MARK: - IBOutlet
	@IBOutlet weak var labWind: UILabel!
	@IBOutlet weak var labHumidity: UILabel!
	@IBOutlet weak var labTemperatureMax: UILabel!
	@IBOutlet weak var labTemperature: UILabel!
	@IBOutlet weak var labDayMonth: UILabel!
	@IBOutlet weak var imgIconWeather: UIImageView!
	@IBOutlet weak var labCity: UILabel!
	
	//MARK: - Vars
	var locationManager = CLLocationManager()
	var latitude: CLLocationDegrees = 0.0;
	var longitude: CLLocationDegrees = 0.0;
	var apikeyWeather: String?
	var disposed = DisposeBag()
	
	//url de imagens
	//
	
	override func viewDidLoad() {
		super.viewDidLoad()
		locationManager.delegate = self
		
		
		if let keyWeahter = ProcessInfo.processInfo.environment["API_KEY_WEATHER"] {
			apikeyWeather = keyWeahter;
		}
		
		populetedView()
		
		
		locationManager.requestAlwaysAuthorization()
		locationManager.requestLocation()
	}
	
	func populetedView() {
		
		if let key = apikeyWeather {
			
			let url = URL(string:
											"https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(key)")!
			
			let resource = Resource<Weather>(url: url)
			
			//se nao conseguir instanciar a funcao pode ser falta do static
			URLRequest.load(resource).subscribe(onNext:{[self]response in
				
				DispatchQueue.main.async {
					self.preapareViewWeather(response)
				}
				
		
				
			}).disposed(by: disposed)
			
		}
		
	}
	
	
	func preapareViewWeather(_ response: Weather)  {

		labWind.text = "\(response.wind.speed)"
		labHumidity.text = "\(response.main.humidity)"
		labTemperature.text = "\(response.main.temp)"
		labTemperatureMax.text = "\(response.main.tempMax)"
		
		//referencia
		//https://cocoacasts.com/fm-3-download-an-image-from-a-url-in-swift
		let urlImgData = URL(string:"http://openweathermap.org/img/wn/\(response.weather[0].icon)@2x.png")!
		
		DispatchQueue.global().async {
			
			if let img = try? Data(contentsOf: urlImgData) {
				DispatchQueue.main.async {
					
					self.imgIconWeather.image = UIImage(data: img);
					
				}
				
			}
			
		}
		
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
			latitude = location.coordinate.latitude
			longitude = location.coordinate.longitude
			
			
			//para pegar address
			//referencia
			//https://stackoverflow.com/questions/41358423/swift-generate-an-address-format-from-reverse-geocoding
			var coordinate = CLLocationCoordinate2D()
			let geocoder = CLGeocoder()
			coordinate.latitude = latitude
			coordinate.longitude = longitude
			
			let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
			
			geocoder.reverseGeocodeLocation(location) { placemarks, error in
				
				if error == nil {
					let pm = placemarks! as [CLPlacemark]
					
					if pm.count > 0  {
						let pm = placemarks![0]
						guard let city = pm.locality, let state = pm.administrativeArea else {return}
						
						self.labCity.text = "\(city), \(state)"
						//						print(pm.country) // pais
						//						print(pm.locality) // cidade
						//						print(pm.subLocality) // bairro
						//						print(pm.administrativeArea)// estado
						
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

