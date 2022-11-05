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
	@IBOutlet weak var viewIsLoading: UIView!
	@IBOutlet weak var labCity: UILabel!
	@IBOutlet weak var viewWeather: UIView!
	@IBOutlet weak var activyIsLoading: UIActivityIndicatorView!
	
	//MARK: - Vars
	var locationManager = CLLocationManager()
	var apikeyWeather: String?
	var disposed = DisposeBag()
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		locationManager.delegate = self
	
		activyIsLoading.startAnimating()
		viewWeather.layer.cornerRadius = 7
		viewWeather.layer.shadowOffset.height = 4
		viewWeather.layer.shadowColor = UIColor.black.cgColor
		viewWeather.layer.shadowOpacity = 0.5
	
		let dateWithoutFormated = Date()
		if #available(iOS 15.0, *) {
			
			let dateFormated = dateWithoutFormated.formatted(date: .complete, time: .omitted).split(separator:  " ")
			
			labDayMonth.text = "\(dateFormated[0].capitalized) \(dateFormated[3].capitalized) \(dateFormated[1])"

		} else {
			labDayMonth.text = "Need update your iphone to version 15"
		}
		
		
		if let keyWeahter = ProcessInfo.processInfo.environment["API_KEY_WEATHER"] {
			apikeyWeather = keyWeahter;
		}
		
		
		
		//precisa passar no info PLIST
		//Privacy - Location Always and When In Use Usage Description
		
		//Privacy - Location When In Use Usage Description
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
		locationManager.startUpdatingLocation()
		
	}
	
	func populetedViewWeather(latitude: CLLocationDegrees,longitude: CLLocationDegrees) {
		
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
		
		labWind.text = "\(String(format: "%.0f",response.wind.speed))m/s"
		labHumidity.text =  String(format: "%.0f",response.main.humidity)
		labTemperature.text = String(format: "%.0f",response.main.temp)
		labTemperatureMax.text = String(format: "%.0f",response.main.tempMax)
		
		//precisas aidcionar no info plist securty
		//referencia https://stackoverflow.com/questions/24016142/how-to-make-http-request-in-swift
		
		//<key>NSAppTransportSecurity</key>
		//		<dict>
		//			<key>NSAllowsArbitraryLoads</key>
		//			<true/>
		//	</dict>
		
		
		//referencia
		//https://cocoacasts.com/fm-3-download-an-image-from-a-url-in-swift
		let imgData = URL(string:"http://openweathermap.org/img/wn/\(response.weather[0].icon)@2x.png")!
		
		DispatchQueue.global().async {
			
			if let data = try? Data(contentsOf: imgData) {
				
				DispatchQueue.main.async {
					self.imgIconWeather.image = UIImage(data: data)
					self.viewIsLoading.isHidden = true
					self.activyIsLoading.stopAnimating()
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
			let latitude = location.coordinate.latitude
			let longitude = location.coordinate.longitude
			
			
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
		
			//assim garanto que sera sempre chamado so apos pegar a latitude e longitude
			populetedViewWeather(latitude: latitude, longitude: longitude)
			locationManager.stopUpdatingLocation()
			
		}
		
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
	
	
}

