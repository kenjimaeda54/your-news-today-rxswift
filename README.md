# Seu guia de notícias
Simples APP com noticiais atuais e a condições do tempo

# Motivação
Reforçar conceitos de RxSwift e MVVM

## Features 
- Para obter a imagem através de um link em uma  requisição pode usar o data 
- [Referencia](https://cocoacasts.com/fm-3-download-an-image-from-a-url-in-swift)
- Exemplo abaixo foi feito em http para isto e necessário adicionar permissão no [info.plist](https://stackoverflow.com/questions/24016142/how-to-make-http-request-in-swift)

```swift
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

```
##
- Para obter o endereço do usuário de forma amigável pode usar o método abaixo
- Precisei usar o objeto CLLocationManager() e implementar seu delegate
- [Referencia](https://stackoverflow.com/questions/41358423/swift-generate-an-address-format-from-reverse-geocoding)
- Para usar esse método precisa também adicionar no info plist duas permissões estão no exemplo

```swift
	var locationManager = CLLocationManager()

	override func viewDidLoad() {
    locationManager.delegate = self
    
    //precisa passar no info PLIST
		//Privacy - Location Always and When In Use Usage Description
		
		//Privacy - Location When In Use Usage Description
	  locationManager.requestWhenInUseAuthorization()
	  locationManager.requestLocation()
	  locationManager.startUpdatingLocation()
 }



//MARK: - CLLocationManagerDelegate
extension NewsAppController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		if let location = locations.last {
			let latitude = location.coordinate.latitude
			let longitude = location.coordinate.longitude
			
			
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
			
			populetedViewWeather(latitude: latitude, longitude: longitude)
			locationManager.stopUpdatingLocation()
			
		}
		
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
	
	
}


```

##
- Por fim usei variáveis de ambientes assim projeto minhas as API key
- Como acessar seu [edit scheme](https://developer.apple.com/library/archive/documentation/IDEs/Conceptual/iOS_Simulator_Guide/CustomizingYourExperienceThroughXcodeSchemes/CustomizingYourExperienceThroughXcodeSchemes.html)
- Como implementar as [variáveis](https://www.swiftdevjournal.com/using-environment-variables-in-swift-apps/) 

```swift

  //MARK: - Environment
		if let keyWeahter = ProcessInfo.processInfo.environment["API_KEY_WEATHER"] {
			apikeyWeather = keyWeahter;
		}
		
		
		if let keyNews = ProcessInfo.processInfo.environment["API_KEY_NEWS"] {
			apikeyNews = keyNews;
		}



```
##
- Swift não aceita hiffen nas variáveis decodable para resolver este problema usei CodingKeys

```swift


struct Main:Decodable {
	let temp: Double
	let humidity: Double
	let tempMax: Double
	
	enum CodingKeys: String, CodingKey {
		   case temp
		   case humidity
			 case tempMax = "temp_max"
	 }
	
}



```


