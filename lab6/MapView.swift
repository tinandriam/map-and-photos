//
//  MapView.swift
//  lab6
//
//  Created by Tina Andria on 26/04/2020.
//  Copyright © 2020 Tina Andria. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    let initialLocation = CLLocation(latitude: 41.65606, longitude: -0.87734)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        makeFocus(on: initialLocation);
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if var text = textField.text {
            text = (text as NSString).replacingCharacters(in: range, with: "")
            let allowedSet = CharacterSet(charactersIn: "0123456789-.")
            let newChars = CharacterSet(charactersIn: string)
            if !newChars.isSubset(of: allowedSet) {
                return false
            }
            if (string == "-" && !text.isEmpty) || string == "." && (text.isEmpty || text.contains(".")) {
                return false
            }
        }
        return true
    }
    
    @IBAction func goTo(_ sender: Any) {
        if latitudeTextField.text == "" || longitudeTextField.text == "" {
            let title = "ERROR"
            let message = "Both coordinates have to be written"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(acceptAction)
            present(alert, animated: true, completion: nil)
        } else if verifyValidity(latitude: Double(latitudeTextField.text ?? "0")!, longitude: Double(longitudeTextField.text ?? "0")!) == false {
            let title = "ERROR"
            let message = "Latitude have to be in range [-90,90]\n Longitude has to be in range [-180,180]"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(acceptAction)
            present(alert, animated: true, completion: nil)
        } else {
            if let lat = Double(latitudeTextField?.text ?? "0"), let long = Double(longitudeTextField?.text ?? "0") {
                let locationToFocusOn = CLLocation(latitude: lat, longitude: long)
                makeFocus(on: locationToFocusOn)
            }
        }
        latitudeTextField.resignFirstResponder()
        longitudeTextField.resignFirstResponder()
    }
    
    func verifyValidity(latitude latitudeValue: Double, longitude longitudeValue: Double) -> Bool {
        if (latitudeValue > 90 || latitudeValue < -90 || longitudeValue > 180 || longitudeValue < -180) {
            return false
        }
        return true
    }
    
    func makeFocus(on location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 6000)
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 30000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        mapView.centerToLocation(location)
        mapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView , rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0

        return renderer
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

