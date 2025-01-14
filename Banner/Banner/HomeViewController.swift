//
//  HomeViewController.swift
//  Banner
//
//  Created by Keitaro Kawahara on 2023/05/27.
//

import CoreLocation
import MapKit
import UIKit

final class HomeViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var mapView: MKMapView!
    private var locationManager = CLLocationManager()

    init() {
        super.init(nibName: R.nib.homeViewController.name, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        setupMapView()
        print("CLLocationManager.authorizationStatus=\(CLLocationManager.authorizationStatus().description)")
    }

    @IBAction func onRequestAlways(_ sender: Any) {
        locationManager.requestAlwaysAuthorization()
    }

    @IBAction func onRequestWhenInUse(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension HomeViewController {
    // 位置情報の許可のステータス変更で呼ばれる
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization status=\(status.description)")
        switch status {
        case .authorizedAlways:
            manager.requestLocation()
            break
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
            break
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations locations=\(locations)")
        let location = locations.first
        guard
            let latitude = location?.coordinate.latitude,
            let longitude = location?.coordinate.longitude
        else {
            return
        }
        var locationData = Location(latitude: latitude, longitude: longitude)
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
        print(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError error=\(error.localizedDescription)")
    }

    private func setupMapView() {
        // ユーザーの現在位置を取得
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // 地図の初期表示領域を設定
        let initialLocation = locationManager.location ?? CLLocation(latitude: 35.6895, longitude: 139.6917)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)

        // ピンを追加
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation.coordinate
        mapView.addAnnotation(annotation)
    }
}

private extension HomeViewController {
    @IBAction func getLocation() {
        let locationModel = LocationModel()
        locationModel.setUpLocation()
        //        locationModel.locationManagerDidChangeAuthorization(locationManage)
    }
}
